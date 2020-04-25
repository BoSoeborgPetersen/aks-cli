# TODO: REFACTOR!!!
# TODO: Refactor into smaller functions.
# TODO: Check Usage.
param($resourceGroupName, $windowsAdminUsername, $windowsAdminPassword, $location, $nodeCount, $nodeSize, $windowsNodeCount, $windowsNodeSize, $windowsNodepoolName)

WriteAndSetUsage "aks create windows <resource group name> <windows admin username> <windows admin password> [location] [node count] [node size] [windows node count] [windows node size] [windows nodepool name]"

$nodeSizeString = ""
SetDefaultIfEmpty ([ref]$nodeSizeString) " --node-vm-size $nodeSize"
SetDefaultIfEmpty ([ref]$windowsNodeSize) "Standard_H8"
SetDefaultIfEmpty ([ref]$windowsNodepoolName) 'winvms'

$resourceGroupExist = ExecuteQuery "az group exists -n $resourceGroupName $debugString"
if (!$resourceGroupExist -and !$location) {
    WriteUsage
    Write-Error "When the resource group does not exist, the location must be specified: [location]"
    exit
}
CheckLocationExists $location
CheckNumberRange ([ref]$nodeCount) "node count" -min 2 -max 100 -default 2
CheckNumberRange ([ref]$windowsNodeCount) "windows node count" -min 2 -max 100 -default 2

CheckVariable $resourceGroupName "resource group name"
CheckVariable $windowsAdminUsername "windows admin username"
CheckVariable $windowsAdminPassword "windows admin password"

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
ExecuteCommand "az extension update -n aks-preview $debugString"

# TODO: Try to remove -l and see if it still works, because of the resource group being specified.
ExecuteCommand "az aks create -g $resourceGroupName -n $clusterName -l $location -c $nodeCount -k $clusterVersion --service-principal $servicePrincipalId --client-secret $servicePrincipalPassword $nodeSizeString --generate-ssh-keys --vm-set-type VirtualMachineScaleSets --windows-admin-password $windowsAdminPassword --windows-admin-username $windowsAdminUsername --network-plugin azure $debugString"
ExecuteCommand "az aks nodepool add --cluster-name $clusterName -n $windowsNodepoolName -g $resourceGroupName -c $windowsNodeCount -s $windowsNodeSize -k $clusterVersion --os-type Windows $debugString"