param($globalSubscription)

WriteAndSetUsage "aks service-principal check" ([ordered]@{
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

Write-Info "Checking current AKS cluster service principal"
$id = AzAksCurrentQuery "show" -q servicePrincipalProfile -o tsv
AzCheckRoleAssignment $id $subscriptionId $resourceGroup
AzCheckRoleAssignment $id $globalSubscriptionId $globalResourceGroup
Write-Info "Current AKS cluster service principal exists"