# TODO: Refactor into smaller functions.
# TODO: Check Usage.
param($resourceGroupName, $windowsAdminUsername, $windowsAdminPassword, $location, $nodeCount, $nodeSize, $windowsNodeCount, $windowsNodeSize, $windowsNodepoolName)

$usage = Write-Usage "aks create windows <resource group name> <windows admin username> <windows admin password> [location] [node count] [node size] [windows node count] [windows node size] [windows nodepool name]"

SetDefaultIfEmpty ([ref]$nodeCount) 2
$nodeSizeString = ""
SetDefaultIfEmpty ([ref]$nodeSizeString) " --node-vm-size $nodeSize"
SetDefaultIfEmpty ([ref]$windowsNodeCount) 2
SetDefaultIfEmpty ([ref]$windowsNodeSize) "Standard_H8"
SetDefaultIfEmpty ([ref]$windowsNodepoolName) 'winvms'

ValidateNumberRange $usage ([ref]$nodeCount) "node count" 2 100
ValidateNumberRange $usage ([ref]$windowsNodeCount) "windows node count" 2 100

VerifyVariable $usage $resourceGroupName "resource group name"
VerifyVariable $usage $windowsAdminUsername "windows admin username"
VerifyVariable $usage $windowsAdminPassword "windows admin password"

$resourceGroupExist = ExecuteQuery "az group exists -n $resourceGroupName $debugString"
if (!$resourceGroupExist -and !$location) {
    Write-Info $usage
    Write-Error "When the resource group does not exist, the location must be specified: [location]"
    exit
}

if ($resourceGroupExist)
{
    $location = ExecuteQuery "az group show -n $resourceGroupName --query location $debugString"
}
else {
    ExecuteCommand "az group create -n $resourceGroupName -l $location $debugString"
}

$clusterName = ResourceGroupToClusterName $resourceGroupName
$keyVaultName = ResourceGroupToKeyVaultName $resourceGroupName
$servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
$servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName

$clusterVersion = ExecuteQuery "az aks get-versions -l $location --query 'orchestrators[?!isPreview].orchestratorVersion | sort(@) | [-1]' $debugString"
$servicePrincipalId = ExecuteQuery "az keyvault secret list --vault-name $keyVaultName --query `"[?id!=null]|[?contains(id, '$servicePrincipalIdName')].[id]`" -o tsv $debugString"

if (!$servicePrincipalId)
{
    ExecuteCommand "aks service-principal create $resourceGroupName"
    $servicePrincipalId = ExecuteQuery "az keyvault secret show -n $servicePrincipalIdName --vault-name $keyVaultName --query value $debugString"
}

$servicePrincipalPassword = ExecuteQuery "az keyvault secret show -n $servicePrincipalPasswordName --vault-name $keyVaultName --query value $debugString"

ExecuteCommand "az provider register -n Microsoft.ContainerService $debugString"
ExecuteCommand "az feature register -n WindowsPreview --namespace Microsoft.ContainerService $debugString"
ExecuteCommand "az extension add -n aks-preview $debugString"

ExecuteCommand "az aks create -g $resourceGroupName -n $clusterName -l $location -c $nodeCount -k $clusterVersion --service-principal $servicePrincipalId --client-secret $servicePrincipalPassword $nodeSizeString --generate-ssh-keys --vm-set-type VirtualMachineScaleSets --windows-admin-password $windowsAdminPassword --windows-admin-username $windowsAdminUsername --network-plugin azure $debugString"
ExecuteCommand "az aks nodepool add --cluster-name $clusterName -n $windowsNodepoolName -g $resourceGroupName -c $windowsNodeCount -s $windowsNodeSize -k $clusterVersion --os-type Windows $debugString"