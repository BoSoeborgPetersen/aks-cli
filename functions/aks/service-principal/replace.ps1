# TODO: If key vault does not exist, then create it.
# TODO: If no service principal exists for the cluster name then create service principal and add it to the key vault.

$usage = Write-Usage "aks service-principal replace"

VerifyCurrentCluster $usage

$resourceGroupName = $selectedCluster.ResourceGroup
$clusterName = $selectedCluster.Name
$keyVaultName = ResourceGroupToKeyVaultName $resourceGroupName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName

if (AreYouSure)
{
    $servicePrincipalId = ExecuteQuery "az keyvault secret show -n $servicePrincipalIdName --vault-name $keyVaultName --query value $debugString"
    $servicePrincipalPassword = ExecuteQuery "az keyvault secret show -n $servicePrincipalPasswordName --vault-name $keyVaultName --query value $debugString"

    ExecuteCommand "az aks update-credentials -n $clusterName -g $resourceGroupName --reset-service-principal --service-principal $servicePrincipalId --client-secret $servicePrincipalPassword $debugString"
}