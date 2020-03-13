# TODO: Implement & Test
# TODO: Create 'Migrate' menu
param($resourceGroupName, $windowsAdminUsername, $windowsAdminPassword, $location, $nodeCount, $nodeSize, $windowsNodeCount, $windowsNodeSize, $windowsNodePoolName)

$usage = Write-Usage "aks setup windows <resource group name> <windows admin username> <windows admin password> [location] [node count] [node size] [windows node count] [windows node size] [windows nodepool name]"

SetDefaultIfEmpty ([ref]$windowsNodePoolName) 'winvms'
SetDefaultIfEmpty ([ref]$nodeCount) 2
$nodeSizeString = ""
SetDefaultIfEmpty ([ref]$nodeSizeString) " --node-vm-size $nodeSize"
SetDefaultIfEmpty ([ref]$windowsNodeCount) 2
SetDefaultIfEmpty ([ref]$windowsNodeSize) "Standard_H8"

ValidateNumberRange $usage ([ref]$nodeCount) "node count" 2 100
ValidateNumberRange $usage ([ref]$windowsNodeCount) "windows node count" 2 100

VerifyVariable $usage $resourceGroupName "resource group name"
VerifyVariable $usage $windowsAdminUsername "windows admin username"
VerifyVariable $usage $windowsAdminPassword "windows admin password"

$resourceGroupExist = ExecuteQuery ("az group exists -n $resourceGroupName $debugString")

if (!$resourceGroupExist -and !$location) {
    Write-Host $usage
    Write-Info "When the resource group does not exist, the location must be specified: [location]"
    exit
}

ExecuteCommand "aks create windows $resourceGroupName $windowsAdminUsername $windowsAdminPassword $location $nodeCount $nodeSize $windowsNodeCount $windowsNodeSize $windowsNodePoolName"

ExecuteCommand "aks credentials get $resourceGroupName"

ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks monitoring install"
ExecuteCommand "aks analytics install"