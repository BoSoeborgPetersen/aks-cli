# TODO: Break up into sub functions
# TODO: Refactor

param($resourceGroupName, $createGlobalResourcesIfNonExistant, $location)

$usage = Write-Usage "aks service-principal create <resource group name> [create global resources if non existant] [location]"

SetDefaultIfEmpty ([ref]$createGlobalResourcesIfNonExistant) $FALSE
ValidateBooleanType $usage $createGlobalResourcesIfNonExistant "create global resources if non existent"

VerifyCurrentSubscription $usage

# Clear-Host
Write-Info "Select the Subscription of the Key Vault"
$globalAccount = ChooseAzureAccount
$globalAccountId = $globalAccount.Id
$globalAccountName = $globalAccount.Name

$selectedAccountId = $selectedAccount.Id
$clusterName = ResourceGroupToClusterName $resourceGroupName
$servicePrincipalName = ClusterToServicePrincipalName $clusterName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName
$globalResourceGroupName = ResourceGroupToGlobalResourceGroupName $resourceGroupName
$registryName = ResourceGroupToRegistryName $resourceGroupName
$keyVaultName = ResourceGroupToKeyVaultName $resourceGroupName

$resourceGroupExist = ExecuteQuery "az group list --query `"[?contains(name, '$resourceGroupName')]`" -o tsv $debugString"

if (!$resourceGroupExist -and !$location) {
    Write-Info $usage
    Write-Error "When the resource group does not exist, the location must be specified: [location]"
    exit
}

if ($resourceGroupExist)
{
    $location = ExecuteQuery ("az group show -g $resourceGroupName --query location $debugString")
}
else {
    ExecuteCommand ("az group create -g $resourceGroupName -l $location $debugString")
}

$globalResourceGroupExist = ExecuteQuery "az group show -g $globalResourceGroupName --query name --subscription $globalAccountName -o tsv $debugString"
$registryExist = ExecuteQuery "az acr show -n $registryName --subscription $globalAccountName -o tsv $debugString"
$keyvaultExist = ExecuteQuery "az keyvault show -n $keyVaultName --subscription $globalAccountName -o tsv $debugString"

if ($createGlobalResourcesIfNonExistant -eq $True)
{
    if (!$globalResourceGroupExist) {
        ExecuteCommand "az group create -g $globalResourceGroupName -l $location --subscription $globalAccountName $debugString"
        $globalResourceGroupExist = ExecuteQuery "az group show -g $globalResourceGroupName --query name --subscription $globalAccountName -o tsv $debugString"
    }

    if (!$registryExist) {
        ExecuteCommand "az acr create -n $registryName -g $globalResourceGroupName --sku Standard --subscription $globalAccountName $debugString"
        $registryExist = ExecuteQuery "az acr show -n $registryName --query name --subscription $globalAccountName -o tsv $debugString"
    }
    
    if (!$keyvaultExist) {
        ExecuteCommand "az keyvault create -n $keyvaultName -g $globalResourceGroupName --subscription $globalAccountName $debugString"
        $keyvaultExist = ExecuteQuery "az keyvault show -n $keyVaultName --query name --subscription $globalAccountName -o tsv $debugString"
    }
}

# TODO: Continue refactor...
if ($registryExist -and $keyvaultExist)
{
    $servicePrincipal = ExecuteCommand "az ad sp create-for-rbac -n $servicePrincipalName --role contributor --years 300 --scopes /subscriptions/$selectedAccountId/resourceGroups/$resourceGroupName /subscriptions/$globalAccountId/resourceGroups/$globalResourceGroupName $debugString" | ConvertFrom-Json

    $loggedInUsername = ExecuteQuery "az account show --query user.name -o tsv $debugString"
    ExecuteCommand "az keyvault set-policy -n $keyvaultName --secret-permissions get list set --upn $loggedInUsername --subscription $globalAccountName $debugString"

    ExecuteCommand ("az keyvault secret set -n $servicePrincipalIdName --vault-name $keyVaultName --value $($servicePrincipal.AppId) --subscription $globalAccountName $debugString")
    ExecuteCommand ("az keyvault secret set -n $servicePrincipalPasswordName --vault-name $keyVaultName --value $($servicePrincipal.Password) --subscription $globalAccountName $debugString")
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