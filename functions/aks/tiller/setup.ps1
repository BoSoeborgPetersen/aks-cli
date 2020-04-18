$usage = Write-Usage "aks tiller setup"

VerifyCurrentCluster $usage

$installed = ExecuteQuery "kubectl get deploy tiller-deploy -n kube-system"

if($installed)
{
    Write-Info ("Tiller (Helm server-side) is installed")
    ExecuteCommand ("aks tiller update")
}
else
{
    Write-Info ("Tiller (Helm server-side) is not installed")
    ExecuteCommand ("aks tiller install")
}
