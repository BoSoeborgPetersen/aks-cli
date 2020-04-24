# TODO: Break up into sub functions
# TODO: Refactor
# TODO: Fix parameter name 'createGlobalResourcesIfNonExistant'.
param($group, $location, $createGlobalResourcesIfNonExistant)

WriteAndSetUsage "aks service-principal create <group> [location] [create global resources if non existant]"

CheckVariable $group "resource group name"
CheckLocationExists $location
# TODO: Join next two functions.
SetDefaultIfEmpty ([ref]$createGlobalResourcesIfNonExistant) $FALSE
CheckBooleanType $createGlobalResourcesIfNonExistant "create global resources if non existent"

# Clear-Host
Write-Info "Select the Subscription of the Key Vault"
$globalSubscription = ChooseAzureSubscription
$globalSubscriptionId = $globalSubscription.Id
$globalSubscriptionName = $globalSubscription.Name

$subscriptionId = $GlobalCurrentSubscription.Id
$clusterName = ResourceGroupToClusterName $group
$servicePrincipalName = ClusterToServicePrincipalName $clusterName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName
$globalResourceGroupName = ResourceGroupToGlobalResourceGroupName $group
$registryName = ResourceGroupToRegistryName $group
$keyVaultName = ResourceGroupToKeyVaultName $group

$resourceGroupExist = ExecuteQuery "az group list --query `"[?contains(name, '$group')]`" -o tsv $debugString"

if (!$resourceGroupExist -and !$location) {
    WriteUsage
    Write-Error "When the resource group does not exist, the location must be specified: [location]"
    exit
}

if ($resourceGroupExist)
{
    $location = ExecuteQuery "az group show -g $group --query location $debugString"
}
else {
    ExecuteCommand "az group create -g $group -l $location $debugString"
}

$globalResourceGroupExist = ExecuteQuery "az group show -g $globalResourceGroupName --query name --subscription '$globalSubscriptionName' -o tsv $debugString"
$registryExist = ExecuteQuery "az acr show -n $registryName --subscription '$globalSubscriptionName' -o tsv $debugString"
$keyvaultExist = ExecuteQuery "az keyvault show -n $keyVaultName --subscription '$globalSubscriptionName' -o tsv $debugString"

if ($createGlobalResourcesIfNonExistant -eq $True)
{
    if (!$globalResourceGroupExist) {
        ExecuteCommand "az group create -g $globalResourceGroupName -l $location --subscription '$globalSubscriptionName' $debugString"
        $globalResourceGroupExist = ExecuteQuery "az group show -g $globalResourceGroupName --query name --subscription '$globalSubscriptionName' -o tsv $debugString"
    }

    if (!$registryExist) {
        ExecuteCommand "az acr create -n $registryName -g $globalResourceGroupName --sku Standard --subscription '$globalSubscriptionName' $debugString"
        $registryExist = ExecuteQuery "az acr show -n $registryName --query name --subscription '$globalSubscriptionName' -o tsv $debugString"
    }
    
    if (!$keyvaultExist) {
        ExecuteCommand "az keyvault create -n $keyvaultName -g $globalResourceGroupName --subscription '$globalSubscriptionName' $debugString"
        $keyvaultExist = ExecuteQuery "az keyvault show -n $keyVaultName --query name --subscription '$globalSubscriptionName' -o tsv $debugString"
    }
}

# TODO: Continue refactor...
if ($registryExist -and $keyvaultExist)
{
    $servicePrincipal = ExecuteCommand "az ad sp create-for-rbac -n $servicePrincipalName --role contributor --years 300 --scopes /subscriptions/$subscriptionId/resourceGroups/$group /subscriptions/$globalSubscriptionId/resourceGroups/$globalResourceGroupName $debugString" | ConvertFrom-Json

    $loggedInUsername = ExecuteQuery "az account show --query user.name -o tsv $debugString"
    ExecuteCommand "az keyvault set-policy -n $keyvaultName --secret-permissions get list set --upn $loggedInUsername --subscription '$globalSubscriptionName' $debugString"

    ExecuteCommand "az keyvault secret set -n $servicePrincipalIdName --vault-name $keyVaultName --value $($servicePrincipal.AppId) --subscription '$globalSubscriptionName' $debugString"
    ExecuteCommand "az keyvault secret set -n $servicePrincipalPasswordName --vault-name $keyVaultName --value $($servicePrincipal.Password) --subscription '$globalSubscriptionName' $debugString"
}
else 
{
    # TODO: More...
    Write-Error "The Service Principal could not be created, as the Azure Container Registry or Azure Key Vault for storing Service Principal did not exist, and it was not specify to create them"
}

Start-Sleep -Seconds 30
# while($ready -ne "True")
# {
#     $ready = ExecuteQuery "az ad sp show --id $servicePrincipalName --query accountEnabled -o tsv $debugString"
# }