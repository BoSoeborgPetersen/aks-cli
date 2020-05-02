# TODO: Check if Service Principal / Managed Identity is already authorized.
param($globalSubscription)

WriteAndSetUsage "aks identity authorize <global subscription>"

CheckCurrentCluster
$resourceGroup = GetCurrentClusterResourceGroup
AzCheckSubscription $globalSubscription
$subscriptionId = GetCurrentSubscription

$globalSubscriptionId = AzQuery "account list" -q `"[?name=='$globalSubscription'].id`" -o tsv
$globalResourceGroup = ResourceGroupToGlobalResourceGroupName $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$registry = ResourceGroupToRegistryName $resourceGroup
AzCheckContainerRegistry $registry $globalSubscription

Write-Info "Authorize AKS cluster Managed Identity to access global resources (cluster Resource Group & Azure Container Registry)"

$id = AzAksCurrentQuery "show" -q identityProfile.kubeletidentity.clientId -o tsv

AzCommand "role assignment create --assignee $id --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
# AzCommand "role assignment create --assignee $id --role contributor --scope /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"
# TODO: Test replacement.
AzAksCurrentCommand "update --attach-acr /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"

