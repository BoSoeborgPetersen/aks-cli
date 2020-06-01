WriteAndSetUsage "aks service-principal replace"

CheckCurrentCluster
$cluster = GetCurrentClusterName
$resourceGroup = GetCurrentClusterResourceGroup

$keyVault = ResourceGroupToKeyVaultName $resourceGroup
$idName = ClusterToServicePrincipalIdName $cluster
$passwordName = ClusterToServicePrincipalPasswordName $cluster

# TODO: Check that Key Vault exists.

# TODO: Refactor into getKeyVaultSecret
$id = AzQuery "keyvault secret show -n $idName --vault-name $keyVault" -q value
CheckVariable $id "id"
# TODO: Refactor into getKeyVaultSecret
$password = AzQuery "keyvault secret show -n $passwordName --vault-name $keyVault" -q value
CheckVariable $password "password"

if (AreYouSure)
{
    AzAksCurrentCommand "update-credentials --reset-service-principal --service-principal $id --client-secret $password"
}