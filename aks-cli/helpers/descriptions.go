package helpers

import v "github.com/spf13/viper"

func AzureLocationDescription(defaulttt string) string {
	// return Format("Azure Location (e.g. 'northeurope')%s", IfF(defaulttt, " (default: %s)"))
	return Format("%s%s", v.GetString("AzureLocationDescription"), IfF(defaulttt, " (default: %s)"))
}

func AzureVmMinNodeCountDescription() string {
	// return "Minimum node (VM) count"
	return v.GetString("AzureVmMinNodeCountDescription")
}

func AzureVmMaxNodeCountDescription() string {
	// return "Maximum node (VM) count"
	return v.GetString("AzureVmMaxNodeCountDescription")
}

func KubernetesDeploymentDescription() string {
	// return "Kubernetes deployment"
	return v.GetString("KubernetesDeploymentDescription")
}

func KubernetesMinPodCountDescription() string {
	// return "Minimum pod count"
	return v.GetString("KubernetesMinPodCountDescription")
}

func KubernetesMaxPodCountDescription() string {
	// return "Maximum pod count"
	return v.GetString("KubernetesMaxPodCountDescription")
}

func KubernetesCpuScalingLimitDescription() string {
	// return "Kubernetes CPU scaling limit"
	return v.GetString("KubernetesCpuScalingLimitDescription")
}

func KubernetesNamespaceDescription() string {
	// return "Kubernetes namespace"
	return v.GetString("KubernetesNamespaceDescription")
}

func KubernetesAllNamespacesDescription() string {
	// return "All Kubernetes namespaces"
	return v.GetString("KubernetesAllNamespacesDescription")
}

func AksVersionDescription(defaulttt string) string {
    // return Format("AKS cluster Version (e.g. '1.16.9')%s", IfF(defaulttt, " (default: %s)"))
    return Format("%s%s", v.GetString("AksVersionDescription"), IfF(defaulttt, " (default: %s)"))
}
