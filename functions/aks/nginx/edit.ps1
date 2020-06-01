param($deployment)

WriteAndSetUsage "aks nginx edit [deployment name]"

CheckCurrentCluster
$nginxDeploymentName = GetNginxDeploymentName $deployment
$configMap = "$nginxDeploymentName-controller"

Write-Info "Edit Nginx configmap"

$configMapExists = KubectlQuery "get configmap" -n ingress -o "jsonpath=`"{$.items[?(@.metadata.name=='$configMap')].metadata.name}`""
if (!$configMapExists)
{
    KubectlCommand "create configmap $configMap" -n ingress
}

KubectlCommand "edit configmap $configMap" -n ingress