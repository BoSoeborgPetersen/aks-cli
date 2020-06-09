param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks keyvault create" ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
})

CheckVariable $resourceGroup "resource group"
CheckVariable $globalSubscription "global subscription"
$globalResourceGroup = GlobalResourceGroupName -resourceGroup $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$keyVault = KeyVaultName -resourceGroup $resourceGroup
AzCheckNotKeyVault $keyVault $globalSubscription

AzCommand "keyvault create -n $keyVault -g $globalResourceGroup --subscription '$globalSubscription'"