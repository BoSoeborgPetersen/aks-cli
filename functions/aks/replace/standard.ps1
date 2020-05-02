# LaterDo: Rewrite to script.
param($resourceGroupName, $location, $minNodeCount, $maxNodeCount, $nodeSize)
 
WriteAndSetUsage "aks replace standard <resource group name> <location> <min node count> <max node count> <node size>"

AzCheckResourceGroup $resourceGroup
AzCheckLocation $location
CheckNumberRange ([ref]$minNodeCount) "min node count" -min 2 -max 100 -default 2
CheckNumberRange ([ref]$maxNodeCount) "max node count" -min 2 -max 100 -default 4

ExecuteCommand "aks create standard $resourceGroupName $location $minNodeCount $maxNodeCount $nodeSize"

ExecuteCommand "aks credentials get $resourceGroupName"

ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks nginx install"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"

# DevOps
$clusterName = ResourceGroupToClusterName $resourceGroupName
# aks service-principal replace
ExecuteCommand "aks devops environment create $clusterName"

# Traffic Managers (redirect traffic)
# ExecuteCommand "aks traffic-manager replace-endpoint"