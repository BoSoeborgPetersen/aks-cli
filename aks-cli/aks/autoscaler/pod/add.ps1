param($deployment, $min = 3, $max = 6, $limit = 60, $namespace)

WriteAndSetUsage ([ordered]@{
    "[deployment]" = KubernetesDeploymentDescription
    "[min]" = KubernetesMinPodCountDescription
    "[max]" = KubernetesMaxPodCountDescription
    "[limit]" = KubernetesCpuScalingLimitDescription
    "[namespace]" = KubernetesNamespaceDescription
})

CheckCurrentCluster
CheckNumberRange $min "min" -min 1 -max 1000
CheckNumberRange $max "max" -min 1 -max 1000
CheckNumberRange $limit "limit" -min 40 -max 80
$deployment = KubectlCheckDeployment $deployment $namespace
KubectlCheckNamespace $namespace

Write-Info "Add pod autoscaler (min: $min, max: $max, cpu limit: $limit) to deployment '$deployment'" -n $namespace

KubectlCommand "autoscale deploy $deployment --min=$min --max=$max --cpu-percent=$limit" -n $namespace