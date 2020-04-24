WriteAndSetUsage "aks tiller setup"

VerifyCurrentCluster

$installed = ExecuteQuery "kubectl get deploy tiller-deploy -n kube-system $kubeDebugString"

if($installed)
{
    Write-Info "Tiller (Helm server-side) is installed"
    ExecuteCommand "aks tiller update"
}
else
{
    Write-Info "Tiller (Helm server-side) is not installed"
    ExecuteCommand "aks tiller install"
}
