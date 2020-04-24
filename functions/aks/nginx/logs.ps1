param($index, $deployment)

WriteAndSetUsage "aks nginx logs [index] [deployment]"

$namespace = "ingress"
CheckCurrentCluster
SetDefaultIfEmpty ([ref]$index) "1"
$nginxDeployment = GetNginxDeploymentName $deployment
KubectlCheckDeployment $deployment -namespace $namespace

if($index)
{
    Write-Info "Show Nginx logs from pod (index: $index) in deployment '$nginxDeployment'"

    $pod = KubectlGetPod $nginxDeployment $namespace $index
    ExecuteCommand "kubectl logs -n $namespace $pod $kubeDebugString"
}
else
{
    Write-Info "Show Nginx logs with Stern"

    ExecuteCommand "stern $nginxDeployment-controller -n $namespace"
}