param($podIndex, $deploymentName)

$usage = Write-Usage "aks nginx logs [pod index] [deployment name]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$podIndex) "0"

$nginxDeploymentName = GetNginxDeploymentName $deploymentName

if($podIndex)
{
    Write-Info "Show Nginx logs from pod (index: $podIndex) in deployment '$nginxDeploymentName'"

    $podName = ExecuteQuery "kubectl get po -l='release=$nginxDeploymentName' -o jsonpath='{.items[$podIndex].metadata.name}' -n ingress $kubeDebugString"
    ExecuteCommand "kubectl logs -n ingress $podName $kubeDebugString"
}
else
{
    Write-Info ("Show Nginx-Ingress logs with Stern")

    ExecuteCommand "stern $nginxDeploymentName-controller -n ingress"
}