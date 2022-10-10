package helpers

func AzureLocationDescription(defaulttt string) string {
	defaultText := ConditionalOperator(defaulttt, Format(" (default: %s)", defaulttt))
	return Format("Azure Location (e.g. 'northeurope')%s", defaultText)
}

func AzureVmMinNodeCountDescription() string {
	return "Minimum node (VM) count"
}

func AzureVmMaxNodeCountDescription() string {
	return "Maximum node (VM) count"
}

func KubernetesDeploymentDescription() string {
	return "Kubernetes deployment"
}

func KubernetesMinPodCountDescription() string {
	return "Minimum pod count"
}

func KubernetesMaxPodCountDescription() string {
	return "Maximum pod count"
}

func KubernetesCpuScalingLimitDescription() string {
	return "Kubernetes CPU scaling limit"
}

func KubernetesNamespaceDescription() string {
	return "Kubernetes namespace"
}

func KubernetesAllNamespacesDescription() string {
	return "All Kubernetes namespaces"
}

// func AksVersionDescription(defaulttt string)
// {
//     defaultText := ConditionalOperator(defaulttt, Format(" (default: %s)", defaulttt))
//     return Format("AKS cluster Version (e.g. '1.16.9')%s", defaultText)
// }
