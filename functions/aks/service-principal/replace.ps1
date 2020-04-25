WriteAndSetUsage "aks service-principal replace"

CheckCurrentCluster

$resourceGroup = $GlobalCurrentCluster.ResourceGroup
$cluster = $GlobalCurrentCluster.Name
$keyVault = ResourceGroupToKeyVaultName $resourceGroup
$idName = ClusterToidNameName $cluster
$passwordName = ClusterToServicePrincipalPasswordName $cluster

# TODO: Check that Key Vault exists.

# TODO: Refactor into getKeyVaultSecret
$id = ExecuteQuery "az keyvault secret show -n $idName --vault-name $keyVault --query value $debugString"
CheckVariable $id "id"
# TODO: Refactor into getKeyVaultSecret
$password = ExecuteQuery "az keyvault secret show -n $passwordName --vault-name $keyVault --query value $debugString"
CheckVariable $password "password"

if (AreYouSure)
{
    ExecuteCommand "az aks update-credentials -n $cluster -g $resourceGroup --reset-service-principal --service-principal $id --client-secret $password $debugString"
}