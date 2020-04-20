param($index, $deployment)

$usage = Write-Usage "aks nginx logs [index] [deployment]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$index) "1"
$nginxDeployment = GetNginxDeploymentName $deployment

VerifyDeployment $deployment

if($index)
{
    Write-Info "Show Nginx logs from pod (index: $index) in deployment '$nginxDeployment'"

    $pod = KubectlGetPod $usage $nginxDeployment "ingress" $index
    ExecuteCommand "kubectl logs -n ingress $pod $kubeDebugString"
}
else
{
    Write-Info "Show Nginx-Ingress logs with Stern"

    ExecuteCommand "stern $nginxDeployment-controller -n ingress"
}