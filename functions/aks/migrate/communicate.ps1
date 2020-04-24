# TODO: Implement & Test
# TODO: Create 'Migrate' menu
param($resourceGroupName, $location, $minNodeCount, $maxNodeCount, $nodeSize)

WriteAndSetUsage "aks migrate communicate <resource group name> <location> [min node count] [max node count] [node size]"

SetDefaultIfEmpty ([ref]$minNodeCount) 2
SetDefaultIfEmpty ([ref]$maxNodeCount) 4

$resourceGroupExist = az group exists -n $resourceGroupName
if (!$resourceGroupExist -and !$location) {
    WriteUsage
    Write-Info "When the resource group does not exist, the location must be specified: [location]"
    exit
}
CheckLocationExists $location
CheckNumberRange ([ref]$minNodeCount) "min node count" -min 2 -max 100 -default 2
CheckNumberRange ([ref]$maxNodeCount) "max node count" -min 2 -max 100 -default 4

$ip = ExecuteQuery "az network public-ip show -g $resourceGroupName -n $ipName --query `"[ipAddress]`" -o tsv $debugString"

ExecuteCommand "aks create standard $resourceGroupName $location $minNodeCount $maxNodeCount $nodeSize"

ExecuteCommand "aks credentials get $resourceGroupName"

ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks nginx install"
ExecuteCommand "aks nginx install `"masterdata`""
ExecuteCommand "aks nginx install `"dme`""
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"