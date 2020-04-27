WriteAndSetUsage "aks delete"

CheckCurrentCluster

Write-Info "Deleting current AKS cluster"
    
if (AreYouSure)
{
    $id = ExecuteQuery "az aks show -g $($GlobalCurrentCluster.ResourceGroup) -n $($GlobalCurrentCluster.Name) --query servicePrincipalProfile -o tsv $debugString"
    
    ExecuteCommand "az aks delete -g $($GlobalCurrentCluster.ResourceGroup) -n $($GlobalCurrentCluster.Name) $debugString"
    ExecuteCommand "az ad sp delete --id $id $debugString"

    # TODO: Call "aks switch" to switch to an existing cluster, or something similar.
}