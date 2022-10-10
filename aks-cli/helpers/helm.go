package helpers

func HelmNamespaceString(namespace string) string {
	return ConditionalOperator(namespace, Format(" -n %s", namespace))
}

func HelmCommand(command string) {
	HelmCommandF(command, "")
}

func HelmCommandF(command string, namespace string) {
	namespaceString := HelmNamespaceString(namespace)

	ExecuteCommand(Format("helm %s%s%s", command, namespaceString, DebugString()))
}

func HelmQuery(command string) string {
	return HelmQueryF(command, "")
}

func HelmQueryF(command string, namespace string) string {
	namespaceString := HelmNamespaceString(namespace)

	return ExecuteQuery(Format("helm %s%s%s", command, namespaceString, DebugString()))
}

func HelmCheck(chart string, namespace string) {
	namespaceString := HelmNamespaceString(namespace)

	// NOWDO: Be quiet!!!
	// check := ExecuteQuery("helm status "+chart+namespaceString+" 2>null")
	check := ExecuteQuery(Format("helm status %s%s", chart, namespaceString))

	if check == "" {
		WriteErrorF(Format("Chart '%s' does not exist", chart), WriteFlags{Namespace: namespace})
	}
}

func HelmLatestChartVersion(chart string) string {
	return HelmQuery("search repo "+chart+" -o json | jq -r ' .[] | select(.name==\""+chart+"\") | .version' | % TrimStart v")
}

func HelmAddRepo(name string, url string) {
	HelmCommand(Format("repo add %s %s", name, url))
	HelmCommand("repo update")
}
