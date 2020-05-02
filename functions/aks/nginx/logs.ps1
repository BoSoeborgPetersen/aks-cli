param($index, $deployment)

WriteAndSetUsage "aks nginx logs [index] [deployment]"

$namespace = "ingress"
CheckCurrentCluster
SetDefaultIfEmpty ([ref]$index) "1"
$nginxDeployment = GetNginxDeploymentName $deployment
KubectlCheckDeployment ([ref]$deployment) -namespace $namespace -allowEmpty

if($index)
{
    Write-Info "Show Nginx logs from pod (index: $index) in deployment '$nginxDeployment'"

    $pod = KubectlGetPod $nginxDeployment $namespace $index
    KubectlCommand "logs -n $namespace $pod"
}
else
{
    Write-Info "Show Nginx logs with Stern"

    ExecuteCommand "stern $nginxDeployment-controller -n $namespace"
}