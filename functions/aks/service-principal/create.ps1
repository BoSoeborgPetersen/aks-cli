param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks service-principal create <resource group> <global subscription>"

AzCheckResourceGroup $resourceGroup
AzCheckSubscription $globalSubscription

$subscriptionId = GetCurrentSubscription
$clusterName = ResourceGroupToClusterName $resourceGroup
$servicePrincipalName = ClusterToServicePrincipalName $clusterName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName

$registry = AzQuery "acr list" -q [].name -o tsv -s $globalSubscription
AzCheckContainerRegistry $registry $globalSubscription
$globalSubscriptionId = AzQuery "account list" -q "`"[?name=='$globalSubscription'].id`"" -o tsv
$globalResourceGroup = AzQuery "acr list" -q "`"[?name=='$registry'].resourceGroup`"" -o tsv -s $globalSubscription
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$keyVault = ResourceGroupToKeyVaultName $resourceGroup
AzCheckKeyVault $keyVault $globalSubscription

$servicePrincipal = AzCommand "ad sp create-for-rbac -n $servicePrincipalName --role contributor --years 300 --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroup /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup" | ConvertFrom-Json

$loggedInUsername = AzQuery "account show" -q user.name -o tsv
AzCommand "keyvault set-policy -n $keyvault --secret-permissions get list set --upn $loggedInUsername --subscription '$globalSubscription'"

AzCommand "keyvault secret set -n $servicePrincipalIdName --vault-name $keyVault --value $($servicePrincipal.AppId) --subscription '$globalSubscription'"
AzCommand "keyvault secret set -n $servicePrincipalPasswordName --vault-name $keyVault --value '$($servicePrincipal.Password)' --subscription '$globalSubscription'"