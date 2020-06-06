# TODO: Check if Managed Identity is authorized.
# TODO: With more than 1 registry in the global subscription, show menu to choose.

param($globalSubscription)

WriteAndSetUsage "aks identity unauthorize <global subscription>"

CheckCurrentCluster
CheckVariable $globalSubscription "global subscription"
$resourceGroup = GetCurrentClusterResourceGroup
AzCheckSubscription $globalSubscription
$subscriptionId = GetCurrentSubscription

$registry = AzQuery "acr list" -q [].name -o tsv -s $globalSubscription
AzCheckContainerRegistry $registry $globalSubscription
$globalSubscriptionId = AzQuery "account list" -q "`"[?name=='$globalSubscription'].id`"" -o tsv
$globalResourceGroup = AzQuery "acr list" -q "`"[?name=='$registry'].resourceGroup`"" -o tsv -s $globalSubscription
AzCheckResourceGroup $globalResourceGroup $globalSubscription

Write-Info "Unauthorize AKS cluster Managed Identity from accessing global resources: 
 - Cluster Resource Group
 - Azure Container Registry"

$systemId = AzAksCurrentQuery "show" -q identity.principalId -o tsv
$userId = AzAksCurrentQuery "show" -q identityProfile.kubeletidentity.clientId -o tsv
 
AzCommand "role assignment delete --assignee $systemId --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup"
AzCommand "role assignment delete --assignee $userId --role contributor --scope /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup"