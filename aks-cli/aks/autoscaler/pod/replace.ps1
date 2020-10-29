param($deployment, $min, $max, $limit, $namespace)

WriteAndSetUsage ([ordered]@{
    "[deployment]" = KubernetesDeploymentDescription
    "[min]" = KubernetesMinPodCountDescription
    "[max]" = KubernetesMaxPodCountDescription
    "[limit]" = KubernetesCpuScalingLimitDescription
    "[namespace]" = KubernetesNamespaceDescription
})

Write-Info "Replace pod autoscaler for deployment '$deployment'"

AksCommand autoscaler pod remove $deployment $namespace
AksCommand autoscaler pod add $deployment $min $max $limit $namespace