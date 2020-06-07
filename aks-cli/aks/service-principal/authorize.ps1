# TODO: Check if Service Principal is already authorized.
param($globalSubscription)

WriteAndSetUsage "aks service-principal authorize [global subscription]"

if(!$globalSubscription)
{
    $globalSubscription = (ChooseSubscriptionMenu).Name
}

CheckCurrentCluster
$resourceGroup = GetCurrentClusterResourceGroup
AzCheckSubscription $globalSubscription
$subscriptionId = GetCurrentSubscription

$registry = AzQuery "acr list" -q [].name -o tsv -s $globalSubscription
AzCheckContainerRegistry $registry $globalSubscription
$globalSubscriptionId = AzQuery "account list" -q "`"[?name=='$globalSubscription'].id`"" -o tsv
$globalResourceGroup = AzQuery "acr list" -q "`"[?name=='$registry'].resourceGroup`"" -o tsv -s $globalSubscription
AzCheckResourceGroup $globalResourceGroup $globalSubscription

Write-Info "Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)"

$id = AzAksCurrentQuery "show" -q servicePrincipalProfile -o tsv

AzCommand "role assignment create --assignee $id --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
AzCommand "role assignment create --assignee $id --role contributor --scope /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"
