param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks keyvault create <resource group> <global subscription>"

$globalResourceGroup = ResourceGroupToGlobalResourceGroupName $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$keyVault = ResourceGroupToKeyVaultName $resourceGroup
AzCheckNotKeyVault $keyVault $globalSubscription

AzCommand "keyvault create -n $keyVault -g $globalResourceGroup --subscription '$globalSubscription'"