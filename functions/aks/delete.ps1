WriteAndSetUsage "aks delete"

CheckCurrentCluster

Write-Info "Deleting current AKS cluster"
    
if (AreYouSure)
{
    $id = AzAksCurrentQuery "show" -q servicePrincipalProfile -o tsv
    
    AzAksCurrentCommand "delete"
    AzCommand "ad sp delete --id $id"

    Write-Info "Cluster has been deleted."
    SwitchCurrentCluster -refresh
}