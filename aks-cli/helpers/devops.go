package helpers

import (
	"os"
)

func AzDevOpsCommand(command string) string {
	return AzDevOpsCommandF(command, AzCommandFlags{})
}

func AzDevOpsCommandF(command string, f AzCommandFlags) string {
	return AzCommandF(Format("devops %s", command), f)
}

func AzDevOpsQuery(command string, f AzQueryFlags) string {
	return AzQueryF(Format("devops %s", command), f)
}

func AzDevOpsCheck(resourceType string, name string, namespace string, exit bool) {
	check := AzDevOpsCommandF(Format("%s list", resourceType), AzCommandFlags{Query: Format("[?name=='%s-%s'].name", name, namespace), Output: "tsv"})

	if check == "" {
		WriteErrorF(Format("Resource '%s' of type '%s' does not exist", name, resourceType), WriteFlags{Namespace: namespace})
	}

	if exit {
		os.Exit(1)
	}
}

type AzDevOpsCommandFlags struct {
	Area       string
	Resource   string
	Parameters string
	MethodHttp string
	Filepath   string
	Query      string
	Output     string
}

func AzDevOpsInvokeCommandF(f AzDevOpsCommandFlags) {
	// filepathString := ConditionalOperator(f.Filepath, Format(" --in-file %s", f.Filepath))
	filepathString := ConditionalOperatorFormat(f.Filepath, " --in-file %s")
	apiVersion := AzDevOpsApiVersion()
	project := DevOpsProjectName()
	AzCommandF(Format("devops invoke --area %s --resource %s --route-parameters project=%s %s --http-method %s --api-version %s%s", f.Area, f.Resource, project, f.Parameters, f.MethodHttp, apiVersion, filepathString), AzCommandFlags{Query: f.Query, Output: f.Output})
}

type AzDevOpsQueryFlags struct {
	Area       string
	Resource   string
	Parameters string
	Query      string
	Output     string
}

func AzDevOpsInvokeQueryF(f AzDevOpsQueryFlags) string {
	apiVersion := AzDevOpsApiVersion()
	project := DevOpsProjectName()
	return AzQueryF(Format("devops invoke --area %s --resource %s --route-parameters project=%s --query-parameters %s --http-method GET --api-version %s", f.Area, f.Resource, project, f.Parameters, apiVersion), AzQueryFlags{Query: f.Query, Output: f.Output})
}

func AzDevOpsInvokeCheck(area string, resource string, parameters string, query string, exit bool) {
	check := AzDevOpsInvokeQueryF(AzDevOpsQueryFlags{Area: area, Resource: resource, Parameters: parameters, Query: query, Output: "tsv"})

	if check == "" {
		WriteError("Resource does not exist")
	}

	if exit {
		os.Exit(1)
	}
}

func AzDevOpsApiVersion() string {
	return "7.1-preview"
}

func AzDevOpsEnvironmentId(name string) string {
	return AzDevOpsInvokeQueryF(AzDevOpsQueryFlags{Area: "environments", Resource: "environments", Query: Format("value[?name=='%s'].id", name), Output: "tsv"})
}

func AzDevOpsResourceId(name string) string {
	return AzDevOpsInvokeQueryF(AzDevOpsQueryFlags{Area: "environments", Resource: "kubernetes", Query: Format("value[?name=='%s'].id", name), Output: "tsv"})
}
