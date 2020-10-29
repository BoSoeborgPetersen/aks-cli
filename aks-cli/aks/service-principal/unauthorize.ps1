# TODO: Check if Service Principal is authorized.
param($globalSubscription)

WriteAndSetUsage ([ordered]@{
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
})

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

Write-Info "Unauthorize AKS cluster Service Principal from accessing global resources (cluster Resource Group & Azure Container Registry)"

$id = AzAksCurrentQuery "show" -q servicePrincipalProfile -o tsv

AzCommand "role assignment delete --assignee $id --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
AzCommand "role assignment delete --assignee $id --role contributor --scope /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"
