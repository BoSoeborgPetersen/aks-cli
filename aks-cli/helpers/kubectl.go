package helpers

import (
	"os"
)

type KubectlFlags struct {
	Regex     string
	Namespace string
	Output    string
	JsonPath  string
	PostFix   string
}

func KubectlCommand(command string) string {
	return KubectlCommandF(command, KubectlFlags{})
}

func KubectlCommandF(command string, f KubectlFlags) string {
	regexString := ConditionalOperatorFormat(f.Regex, " | sed -n '/%s/p' ")
	namespaceString := KubectlNamespaceString(f.Namespace)
	outputString := ConditionalOperatorFormat(f.Output, " -o %s")
	outputString = ConditionalOperatorFormat(f.JsonPath, " -o jsonpath=\"%s\"")

	return ExecuteCommand(Format("kubectl %s%s%s%s%s%s", command, namespaceString, outputString, KubeDebugString(), regexString, f.PostFix))
}

func KubectlQuery(query string) string {
	return KubectlQueryF(query, KubectlFlags{})
}

func KubectlQueryF(query string, f KubectlFlags) string {
	regexString := ConditionalOperatorFormat(f.Regex, " | grep -E %s -i")
	namespaceString := KubectlNamespaceString(f.Namespace)
	outputString := ConditionalOperatorFormat(f.Output, " -o %s")
	outputString = ConditionalOperatorOr(f.JsonPath, Format(" -o jsonpath=\"%s\"", f.JsonPath), outputString)

	return ExecuteQuery(Format("kubectl %s%s%s%s%s%s", query, namespaceString, outputString, KubeDebugString(), regexString, f.PostFix))
}

func KubectlCheck(resourceType string, name string) {
	KubectlCheckF(resourceType, name, "", false)
}

func KubectlCheckF(resourceType string, name string, namespace string, exit bool) {
	namespaceString := KubectlNamespaceString(namespace)

	check := ExecuteQuery(Format("kubectl get %s %s%s%s --ignore-not-found", resourceType, name, namespaceString, KubeDebugString()))

	if check == "" {
		WriteErrorF(Format("Resource '%s' of type '%s' does not exist", name, resourceType), WriteFlags{Namespace: namespace})
	}

	if exit {
		os.Exit(1)
	}
}

// # LaterDo: Check standard error, instead of standard out, otherwise, if one resource exists, the error message is not shown, even though it should be.
func KubectlCheckYaml(file string) {
	check := ExecuteQuery(Format("kubectl get -f %s%s --ignore-not-found", file, KubeDebugString()))

	if check == "" {
		WriteError(Format("Resources in file '%s' do not exist", file))
	}
}

func KubectlClearConfig(resourceGroup string) {
	cluster := ClusterName(resourceGroup)
	contexts := Fields(KubectlQueryF("config get-contexts", KubectlFlags{Output: "name"}))

	if Any(contexts, func(s string) bool { return s == cluster }) {
		KubectlCommand("config unset current-context")

		KubectlCommand(Format("config delete-context %s", cluster))
		KubectlCommand(Format("config delete-cluster %s", cluster))

		username := Format("users.clusterUser_%s_%s", resourceGroup, cluster)

		KubectlCommand(Format("config unset %s", username))
	}
}

func KubectlNamespaceString(namespace string) string {
	return ConditionalOperatorOr(namespace == "all", " -A", ConditionalOperator(namespace, Format(" -n %s", namespace)))
}

func KubectlCheckNamespace(name string) {
	check := name == "" || name == "all" || KubectlQueryF("get ns", KubectlFlags{JsonPath: Format("{$.items[?(@.metadata.name=='%s')].metadata.name}", name)}) != ""
	Check(check, Format("Namespace '%s' does not exist!", name))
}

func KubectlCheckDeployment(name string, namespace string) string {
	if name == "" {
		name = ChooseDeployment(name, namespace)
	}

	check := KubectlQueryF("get deploy", KubectlFlags{Namespace: namespace, JsonPath: Format("{$.items[?(@.metadata.name=='%s')].metadata.name}", name)})
	Check(check, Format("Deployment '%s' in namespace '%s' does not exist!", name, namespace))

	return name
}

func KubectlCheckDaemonSet(name string, namespace string) {
	check := KubectlQueryF(Format("get ds -l release=%s", name), KubectlFlags{Namespace: namespace, JsonPath: "{.items[*].metadata.name}"})
	Check(check, Format("DaemonSet '%s' in namespace '%s' does not exist!", name, namespace))
}

func KubectlGetRegex(resourceType string, regex string, index int, namespace string) (string, string) {
	index = ConditionalOperatorOr(index, index, 0)
	json := KubectlQueryF(Format("get %s", resourceType), KubectlFlags{Namespace: namespace, Output: Format("json | jq '[ .items[] | .metadata | select(.name|test(\"%s\")) | \"\\(.namespace) \\(.name)\" ]'", regex)})
	resourceCount := Atoi(JqCommand(json, "jq. 'length'"))

	Check(resourceCount > 0, Format("No type '%s' matching '%s' in namespace '%s'", resourceType, regex, namespace))
	CheckOptionalNumberRange(index, "index", 0, resourceCount-1)

	results := Fields(JqCommand(json, Format("jq -r \".[%d]\"", index)))
	return results[0], results[1]
}

func KubectlGetPods(deployment string, namespace string) []string {
	return Fields(KubectlQueryF(Format("get po -l app=%s", deployment), KubectlFlags{Namespace: namespace, Output: "json | jq '[ .items[] | .metadata.name ]'"}))
}

func KubectlGetPod(deployment string, namespace string, index int) string {
	index = ConditionalOperatorOr(index, index, 0)
	pods := KubectlGetPods(deployment, namespace)
	CheckOptionalNumberRange(index, "index", 0, len(pods)-1)
	return pods[index]
}

func KubectlCheckPodAutoscaler(name string, namespace string) {
	check := KubectlQueryF("get hpa", KubectlFlags{Namespace: namespace, JsonPath: Format("{$.items[?(@.metadata.name=='%s')].metadata.name}", name)})
	Check(check, Format("Horizontal Pod Autoscaler '%s' in namespace '%s' does not exist!", name, namespace))
}

func KubectlSaveLastApplied(resourceType string, name string, namespace string) {
	KubectlSaveLastAppliedF(resourceType, name, namespace, "yaml", "/app/temp/last-applied")
}

func KubectlSaveLastAppliedF(resourceType string, name string, namespace string, output string, filePath string) {
	var fullFilePath string
	if namespace != "" {
		fullFilePath = Format("%s/%s-%s-%s.%s", filePath, namespace, name, resourceType, output)
	} else {
		fullFilePath = Format("%s/default-%s-%s.%s", filePath, name, resourceType, output)
	}

	WriteInfo(Format("Saving '%s/%s' to '%s'", resourceType, name, fullFilePath))

	if !DirExists(filePath) {
		MakeDir(filePath)
	}
	lastApplied := KubectlQueryF(Format("apply view-last-applied %s %s", resourceType, name), KubectlFlags{Output: output, Namespace: namespace})

	SaveFile(lastApplied, fullFilePath)
}

func KubectlSaveHelmSecret(name string, version string, namespace string, output string, filePath string) {
	KubectlSaveHelmSecretF(name, version, namespace, "json", "/app/temp/helm-secret")
}

func KubectlSaveHelmSecretF(name string, version string, namespace string, output string, filePath string) {
	fullFilePath := Format("%s/sh.helm.release.v1.%s.v%s.%s", filePath, name, version, output)

	WriteInfo(Format("Saving '%s' to '%s'", name, fullFilePath))

	if !DirExists(filePath) {
		MakeDir(filePath)
	}
	secret := KubectlQueryF(Format("get secret sh.helm.release.v1.%s.v%s", name, version), KubectlFlags{Output: output, Namespace: namespace})

	SaveFile(secret, fullFilePath)
}

func KubectlCreateNamespace(name string) {
	check := KubectlQueryF("get ns", KubectlFlags{JsonPath: Format("{$.items[?(@.metadata.name=='%s')].metadata.name}", name)})

	if check == "" {
		KubectlCommand(Format("create ns %s", name))
	}
}
