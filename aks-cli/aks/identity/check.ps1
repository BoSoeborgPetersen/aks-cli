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

Write-Info "Checking Managed Identity"

Write-Info "Checking current AKS cluster managed identity (system assigned)"
$systemId = AzAksCurrentQuery "show" -q identity.principalId -o tsv
AzCheckRoleAssignment $systemId $subscriptionId $resourceGroup
Write-Info "Current AKS cluster managed identity (system assigned) exists"

Write-Info "Checking current AKS cluster managed identity (user assigned)"
$userId = AzAksCurrentQuery "show" -q identityProfile.kubeletidentity.clientId -o tsv
AzCheckRoleAssignment $userId $globalSubscriptionId $globalResourceGroup
Write-Info "Current AKS cluster managed identity (user assigned) exists"

Write-Info "Managed Identity exists"