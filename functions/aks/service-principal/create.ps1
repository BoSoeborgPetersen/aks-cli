param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks service-principal create <resource group> <global subscription>"

AzCheckResourceGroup $resourceGroup
AzCheckSubscription $globalSubscription

$globalSubscriptionId = AzQuery "account list" -q `"[?name==$globalSubscription].id`" -o tsv
$subscriptionId = GetCurrentSubscription

$clusterName = ResourceGroupToClusterName $resourceGroup
$servicePrincipalName = ClusterToServicePrincipalName $clusterName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName

$globalResourceGroup = ResourceGroupToGlobalResourceGroupName $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$registry = ResourceGroupToRegistryName $resourceGroup
AzCheckContainerRegistry $registry $globalSubscription
$keyVault = ResourceGroupToKeyVaultName $resourceGroup
AzCheckKeyVault $keyVault $globalSubscription

$servicePrincipal = AzCommand "ad sp create-for-rbac -n $servicePrincipalName --role contributor --years 300 --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroup /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup" | ConvertFrom-Json

$loggedInUsername = AzQuery "account show" -q user.name -o tsv
AzCommand "keyvault set-policy -n $keyvault --secret-permissions get list set --upn $loggedInUsername --subscription '$globalSubscription'"

AzCommand "keyvault secret set -n $servicePrincipalIdName --vault-name $keyVault --value $($servicePrincipal.AppId) --subscription '$globalSubscription'"
AzCommand "keyvault secret set -n $servicePrincipalPasswordName --vault-name $keyVault --value $($servicePrincipal.Password) --subscription '$globalSubscription'"