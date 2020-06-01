WriteAndSetUsage "aks tiller setup"

CheckCurrentCluster

$installed = KubectlQuery "get deploy tiller-deploy" -n kube-system

if($installed)
{
    Write-Info "Tiller (Helm server-side) is installed"
    ExecuteCommand "aks tiller upgrade"
}
else
{
    Write-Info "Tiller (Helm server-side) is not installed"
    ExecuteCommand "aks tiller install"
}
