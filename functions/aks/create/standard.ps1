# TODO: Refactor into smaller functions.
# TODO: Switch to new cluster after it is created successfully.
# TODO: Replace Azure subscription choice menu with optional parameter that defaults to the current subscription. - Don't default to current subscription.
# TODO: Clear the global list of clusters for the subscription.
param($resourceGroupName, $location, $minNodeCount, $maxNodeCount, $nodeSize)

$usage = Write-Usage "aks create standard <resource group name> <location> [min node count] [max node count] [node size]"

SetDefaultIfEmpty ([ref]$minNodeCount) 2
SetDefaultIfEmpty ([ref]$maxNodeCount) 4

if($nodeSize)
{
    $nodeSizeString1 = "-s"
    $nodeSizeString2 = "$nodeSize"
}

$resourceGroupExist = ExecuteQuery "az group list --query `"[?name!=null]|[?contains(name, '$resourceGroupName')].[name]`" -o tsv $debugString"
if (!$resourceGroupExist -and !$location) {
    Write-Info $usage
    Write-Error "When the resource group does not exist, the location must be specified: [location]"
    exit
}
CheckLocationExists $location
ValidateNumberRange $usage ([ref]$minNodeCount) "min node count" 2 100
ValidateNumberRange $usage ([ref]$maxNodeCount) "max node count" 2 100

if ($resourceGroupExist)
{
    $location = ExecuteQuery "az group show -g $resourceGroupName --query location $debugString"
}
else {
    Write-Info "Creating resource group '$resourceGroupName' in location '$location'"
    ExecuteCommand "az group create -g $resourceGroupName -l $location $debugString"
}

$clusterName = ResourceGroupToClusterName $resourceGroupName
$keyVaultName = ResourceGroupToKeyVaultName $resourceGroupName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName

$clusterVersion = ExecuteQuery "az aks get-versions -l $location --query 'orchestrators[?!isPreview].orchestratorVersion | sort(@) | [-1]' $debugString"
$servicePrincipalExist = ExecuteQuery "az keyvault secret list --vault-name $keyVaultName --query `"[?contains(id, 'https://$keyVaultName.vault.azure.net/secrets/$servicePrincipalIdName')]`" -o tsv $debugString"

if (!$servicePrincipalExist)
{
    ExecuteCommand "aks service-principal create $resourceGroupName $location $True"
}

$servicePrincipalId = ExecuteQuery "az keyvault secret show -n $servicePrincipalIdName --vault-name $keyVaultName --query value $debugString"

$servicePrincipalPassword = ExecuteQuery "az keyvault secret show -n $servicePrincipalPasswordName --vault-name $keyVaultName --query value $debugString"
# TODO: Try to remove -l and see if it still works, because of the resource group being specified.
ExecuteCommand "az aks create -g $resourceGroupName -n $clusterName -l $location -c $minNodeCount -k $clusterVersion $nodeSizeString1 '$nodeSizeString2' --service-principal $servicePrincipalId --client-secret $servicePrincipalPassword --generate-ssh-keys --load-balancer-sku basic --enable-cluster-autoscaler --min-count $minNodeCount --max-count $maxNodeCount $debugString"