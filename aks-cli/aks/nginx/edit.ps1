param($prefix)

WriteAndSetUsage "aks nginx edit" ([ordered]@{
    "[prefix]" = "Kubernetes deployment name prefix"
})

CheckCurrentCluster
$deployment = NginxDeploymentName $prefix
$configMap = "$deployment-controller"

Write-Info "Edit Nginx configmap"

$configMapExists = KubectlQuery "get configmap" -n ingress -j "{$.items[?(@.metadata.name=='$configMap')].metadata.name}"
if (!$configMapExists)
{
    KubectlCommand "create configmap $configMap" -n ingress
}

KubectlCommand "edit configmap $configMap" -n ingress