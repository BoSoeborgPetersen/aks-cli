# TODO: Implement & Test
# TODO: Create 'Migrate' menu
param($resourceGroupName, $location, $minNodeCount, $maxNodeCount, $nodeSize)

$usage = Write-Usage "aks migrate communicate <resource group name> <location> [min node count] [max node count] [node size]"

SetDefaultIfEmpty ([ref]$minNodeCount) 2
SetDefaultIfEmpty ([ref]$maxNodeCount) 4
$nodeSizeString = ""
if($nodeSize)
{
    $nodeSizeString = " --node-vm-size $nodeSize"
}

ValidateNumberRange $usage ([ref]$minNodeCount) "min node count" 2 100
ValidateNumberRange $usage ([ref]$maxNodeCount) "max node count" 2 100

VerifyVariable $usage $resourceGroupName "resource group name"

$ip = ExecuteQuery ("az network public-ip show -g $resourceGroupName -n $ipName --query `"[ipAddress]`" -o tsv $debugString")
$resourceGroupExist = az group exists -n $resourceGroupName
if (!$resourceGroupExist -and !$location) {
    Write-Host $usage
    Write-Info "When the resource group does not exist, the location must be specified: [location]"
    exit
}

ExecuteCommand ("aks create standard $resourceGroupName $location $minNodeCount $maxNodeCount $nodeSize")

ExecuteCommand ("aks credentials get $resourceGroupName")

ExecuteCommand ("aks tiller install")
ExecuteCommand ("aks tiller wait")
ExecuteCommand ("aks nginx install")
ExecuteCommand ("aks nginx install `"masterdata`"")
ExecuteCommand ("aks nginx install `"dme`"")
ExecuteCommand ("aks cert-manager install")
ExecuteCommand ("aks analytics install")