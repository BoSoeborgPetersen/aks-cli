param($deployment, $namespace)

WriteAndSetUsage "aks autoscaler pod remove" ([ordered]@{
    "[deployment]" = KubernetesDeploymentDescription
    "[namespace]" = KubernetesNamespaceDescription
})

CheckCurrentCluster
$deployment = KubectlCheckDeployment $deployment $namespace
KubectlCheckNamespace $namespace

Write-Info "Remove pod autoscaler for deployment '$deployment'" -n $namespace

KubectlCommand "delete hpa $deployment" -n $namespace