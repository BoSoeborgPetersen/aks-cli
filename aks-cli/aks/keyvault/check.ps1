param($resourceGroup, $globalSubscription)

WriteAndSetUsage ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
})

CheckVariable $resourceGroup "resource group"
CheckVariable $globalSubscription "global subscription"
$globalResourceGroup = GlobalResourceGroupName -resourceGroup $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$keyVault = KeyVaultName -resourceGroup $resourceGroup

Write-Info "Checking Keyvault"
AzCheckKeyvault $keyVault $globalSubscription
Write-Info "Keyvault exists"