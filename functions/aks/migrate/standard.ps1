# TODO: Implement & Test
# TODO: Create 'Migrate' menu
param($resourceGroupName, $location, $minNodeCount, $maxNodeCount, $nodeSize)
 
$usage = Write-Usage "aks setup standard <resource group name> <location> <min node count> <max node count> <node size>"

SetDefaultIfEmpty ([ref]$minNodeCount) 2
SetDefaultIfEmpty ([ref]$maxNodeCount) 4

ValidateNumberRange $usage ([ref]$minNodeCount) "min node count" 2 100
ValidateNumberRange $usage ([ref]$maxNodeCount) "max node count" 2 100

VerifyVariable $usage $resourceGroupName "resource group name"

$resourceGroupExist = ExecuteQuery ("az group list --query `"[?name!=null]|[?contains(name, '$resourceGroupName')].[name]`" -o tsv $debugString")

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
ExecuteCommand ("aks cert-manager install")
ExecuteCommand ("aks analytics install")

# DevOps
$clusterName = ResourceGroupToClusterName $resourceGroupName
# aks service-principal replace
ExecuteCommand ("aks devops environment create $clusterName")

# Traffic Managers (redirect traffic)
# ExecuteCommand ("aks traffic-manager replace-endpoint")