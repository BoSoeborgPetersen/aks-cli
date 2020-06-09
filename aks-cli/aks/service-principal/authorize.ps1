# TODO: Check if Service Principal is already authorized.
param($globalSubscription)

WriteAndSetUsage "aks service-principal authorize" ([ordered]@{
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
})

if (!$globalSubscription)
{
    $globalSubscription = (SubscriptionMenu).Name
}

CheckCurrentCluster
CheckVariable $globalSubscription "global subscription"
$resourceGroup = CurrentClusterResourceGroup
AzCheckSubscription $globalSubscription
$subscriptionId = CurrentSubscription

$registry = AzQuery "acr list" -q [].name -o tsv -s $globalSubscription
AzCheckContainerRegistry $registry $globalSubscription
$globalSubscriptionId = AzQuery "account list" -q "[?name=='$globalSubscription'].id" -o tsv
$globalResourceGroup = AzQuery "acr list" -q "[?name=='$registry'].resourceGroup" -o tsv -s $globalSubscription
AzCheckResourceGroup $globalResourceGroup $globalSubscription

Write-Info "Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)"

$id = AzAksCurrentQuery "show" -q servicePrincipalProfile -o tsv

AzCommand "role assignment create --assignee $id --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
AzCommand "role assignment create --assignee $id --role contributor --scope /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"