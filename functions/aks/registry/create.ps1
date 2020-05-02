param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks registry create <resource group> <global subscription>"

$globalResourceGroup = ResourceGroupToGlobalResourceGroupName $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$registry = ResourceGroupToRegistryName $resourceGroup
AzCheckNotContainerRegistry $registry $globalSubscription

AzCommand "acr create -n $registry -g $globalResourceGroup --sku Standard --subscription '$globalSubscription'"