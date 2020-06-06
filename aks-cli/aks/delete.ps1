# LaterDo: Remove role assignments to Cluster Resource Group and Container Registry Group.
# LaterDo: Remove user assigned managed identity if it is still there.
WriteAndSetUsage "aks delete"

CheckCurrentCluster

Write-Info "Deleting current AKS cluster"
    
if (AreYouSure)
{
    $id = AzAksCurrentQuery "show" -q servicePrincipalProfile -o tsv
    # $userId = AzAksCurrentQuery "show" -q identityProfile.kubeletidentity.clientId -o tsv

    # $resourceGroup = GetCurrentClusterResourceGroup
    # $subscriptionId = GetCurrentSubscription
    # $globalSubscriptionId = AzQuery "account list" -q "`"[?name=='$globalSubscription'].id`"" -o tsv
    # $globalResourceGroup = AzQuery "acr list" -q "`"[?name=='$registry'].resourceGroup`"" -o tsv -s $globalSubscription
    
    # if ($id -eq "msi")
    # {
    #     $systemId = AzAksCurrentQuery "show" -q identity.principalId -o tsv
         
    #     AzCommand "role assignment delete --assignee $systemId --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
    #     AzCommand "role assignment delete --assignee $userId --role contributor --scope /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"    
    # }
    # else 
    # {
    #     AzCommand "role assignment delete --assignee $id --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"
    # }

    AzAksCurrentCommand "delete"
    
    if ($id -eq "msi")
    {
        # AzCommand "identity delete "
    }
    else
    {
        AzCommand "ad sp delete --id $id"
    }

    Write-Info "Cluster has been deleted."
    SwitchCurrentCluster -refresh
}