param($index, $deployment)

WriteAndSetUsage "aks nginx logs [index] [deployment]"

VerifyCurrentCluster
SetDefaultIfEmpty ([ref]$index) "1"
$nginxDeployment = GetNginxDeploymentName $deployment

KubectlVerifyDeployment $deployment

if($index)
{
    Write-Info "Show Nginx logs from pod (index: $index) in deployment '$nginxDeployment'"

    $pod = KubectlGetPod $nginxDeployment "ingress" $index
    ExecuteCommand "kubectl logs -n ingress $pod $kubeDebugString"
}
else
{
    Write-Info "Show Nginx-Ingress logs with Stern"

    ExecuteCommand "stern $nginxDeployment-controller -n ingress"
}