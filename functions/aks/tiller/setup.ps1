$usage = Write-Usage "aks tiller setup"

VerifyCurrentCluster $usage

$installed = ExecuteQuery "kubectl get deploy tiller-deploy -n kube-system"

if($installed)
{
    Write-Info ("Tiller (Helm server-side) is installed on current AKS cluster '$($selectedCluster.Name)'")
    ExecuteCommand ("aks tiller update")
}
else
{
    Write-Info ("Tiller (Helm server-side) is not installed on current AKS cluster '$($selectedCluster.Name)'")
    ExecuteCommand ("aks tiller install")
}
