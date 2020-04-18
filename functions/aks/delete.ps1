$usage = Write-Usage "aks delete"

VerifyCurrentCluster $usage

if (AreYouSure)
{
    Write-Info ("Deleting current AKS cluster")
    
    ExecuteCommand ("az aks delete -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) $debugString")
}