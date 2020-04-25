param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks service-principal create <resource group> <global subscription>"

CheckResourceGroupExists $resourceGroup
CheckSubscriptionExists $globalSubscription

$globalSubscriptionId =  "az account list --query `"[?name=='$globalSubscription'].id`" -o tsv"
$subscriptionId = $GlobalCurrentSubscription.Id

$clusterName = ResourceGroupToClusterName $resourceGroup
$servicePrincipalName = ClusterToServicePrincipalName $clusterName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName

$globalResourceGroup = ResourceGroupToGlobalResourceGroupName $resourceGroup
CheckResourceGroupExists $globalResourceGroup $globalSubscription
$registry = ResourceGroupToRegistryName $resourceGroup
CheckContainerRegistryExists $registry $globalSubscription
$keyVault = ResourceGroupToKeyVaultName $resourceGroup
CheckKeyVaultExists $keyVault $globalSubscription

$servicePrincipal = ExecuteCommand "az ad sp create-for-rbac -n $servicePrincipalName --role contributor --years 300 --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroup /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroup $debugString" | ConvertFrom-Json

$loggedInUsername = ExecuteQuery "az account show --query user.name -o tsv $debugString"
ExecuteCommand "az keyvault set-policy -n $keyvault --secret-permissions get list set --upn $loggedInUsername --subscription '$globalSubscription' $debugString"

ExecuteCommand "az keyvault secret set -n $servicePrincipalIdName --vault-name $keyVault --value $($servicePrincipal.AppId) --subscription '$globalSubscription' $debugString"
ExecuteCommand "az keyvault secret set -n $servicePrincipalPasswordName --vault-name $keyVault --value $($servicePrincipal.Password) --subscription '$globalSubscription' $debugString"