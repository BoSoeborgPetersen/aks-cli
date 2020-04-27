# TODO: Check if Service Principal is already authorized.
param($globalSubscription)

WriteAndSetUsage "aks service-principal authorize <global subscription>"

CheckCurrentCluster
CheckSubscriptionExists $globalSubscription
# TODO: Refactor to functions.
$subscriptionId = $GlobalCurrentSubscription.Id
$resourceGroup = $GlobalCurrentCluster.ResourceGroup
$cluster = $GlobalCurrentCluster.Name

$globalSubscriptionId = ExecuteQuery "az account list --query `"[?name=='$globalSubscription'].id`" -o tsv $debugString"
$globalResourceGroup = ResourceGroupToGlobalResourceGroupName $resourceGroup
CheckResourceGroupExists $globalResourceGroup $globalSubscription
$registry = ResourceGroupToRegistryName $resourceGroup
CheckContainerRegistryExists $registry $globalSubscription

Write-Info "Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)"

$id = ExecuteQuery "az aks show -g $resourceGroup -n $cluster --query servicePrincipalProfile -o tsv $debugString"

ExecuteCommand "az role assignment create --assignee $id --role contributor --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroup /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup $debugString"
