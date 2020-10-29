param($deployment, $namespace)

WriteAndSetUsage ([ordered]@{
    "[deployment]" = KubernetesDeploymentDescription
    "[namespace]" = KubernetesNamespaceDescription
})

CheckCurrentCluster
$deployment = KubectlCheckDeployment $deployment $namespace
KubectlCheckNamespace $namespace

Write-Info "Checking pod autoscaler for deployment '$deployment'" -n $namespace
KubectlCheckPodAutoscaler $deployment $namespace
Write-Info "Pod autoscaler exists for deployment '$deployment'" -n $namespace