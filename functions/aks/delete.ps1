$usage = Write-Usage "aks delete"

VerifyCurrentCluster $usage

Write-Info "Deleting current AKS cluster"
    
if (AreYouSure)
{
    ExecuteCommand "az aks delete -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) $debugString"
}