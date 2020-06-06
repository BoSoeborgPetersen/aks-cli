param($index, $deployment)

WriteAndSetUsage "aks nginx logs [index] [deployment]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeployment = GetNginxDeploymentName $deployment
KubectlCheckDaemonSet ([ref]$nginxDeployment) -namespace $namespace

if($index)
{
    Write-Info "Show Nginx logs from pod (index: $index) in deployment '$nginxDeployment'"

    $pod = KubectlGetPod $nginxDeployment $namespace $index
    KubectlCommand "logs -n $namespace $pod"
}
else
{
    Write-Info "Show Nginx logs with Stern"

    ExecuteCommand "stern -l app=$nginxDeployment -n $namespace"
}