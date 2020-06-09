function AzureLocationDescription($default)
{
    $defaultText = ConditionalOperator $default " (default: $default)"
    return ("Azure Location (e.g. 'northeurope')" + $defaultText)
}

function AzureVmMinNodeCountDescription
{
    return "Minimum node (VM) count"
}

function AzureVmMaxNodeCountDescription
{
    return "Maximum node (VM) count"
}

function KubernetesDeploymentDescription
{
    return "Kubernetes deployment"
}

function KubernetesMinPodCountDescription
{
    return "Minimum pod count"
}

function KubernetesMaxPodCountDescription
{
    return "Maximum pod count"
}

function KubernetesCpuScalingLimitDescription
{
    return "Kubernetes CPU scaling limit"
}

function KubernetesNamespaceDescription
{
    return "Kubernetes namespace"
}

function KubernetesAllNamespacesDescription
{
    return "All Kubernetes namespaces"
}

# function AksVersionDescription($default)
# {
#     $defaultText = ConditionalOperator $default " (default: $default)"
#     return ("AKS cluster Version (e.g. '1.16.9')" + $defaultText)
# }