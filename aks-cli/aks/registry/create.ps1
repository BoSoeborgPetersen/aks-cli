param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks registry create" ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<globalSubscription>" = "Azure Subscription for Azure Container Registry"
})

CheckVariable $resourceGroup "resource group"
CheckVariable $globalSubscription "global subscription"
$globalResourceGroup = GlobalResourceGroupName -resourceGroup $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$registry = RegistryName -resourceGroup $resourceGroup
AzCheckNotContainerRegistry $registry $globalSubscription

AzCommand "acr create -n $registry -g $globalResourceGroup --sku Standard --subscription '$globalSubscription'"