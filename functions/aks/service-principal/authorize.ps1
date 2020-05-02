# TODO: Check if Service Principal is already authorized.
param($globalSubscription)

WriteAndSetUsage "aks service-principal authorize <global subscription>"

CheckCurrentCluster
$resourceGroup = GetCurrentClusterResourceGroup
AzCheckSubscription $globalSubscription
$subscriptionId = GetCurrentSubscription

$globalSubscriptionId = AzQuery "account list" -q `"[?name==$globalSubscription].id`" -o tsv
$globalResourceGroup = ResourceGroupToGlobalResourceGroupName $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$registry = ResourceGroupToRegistryName $resourceGroup
AzCheckContainerRegistry $registry $globalSubscription

Write-Info "Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)"

$id = AzAksCurrentQuery "show" -q servicePrincipalProfile -o tsv

AzCommand "role assignment create --assignee $id --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"
