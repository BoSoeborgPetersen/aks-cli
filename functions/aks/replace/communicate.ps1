# LaterDo: Rewrite to script.
param($resourceGroupName, $location, $minNodeCount, $maxNodeCount, $nodeSize)

WriteAndSetUsage "aks replace communicate <resource group name> <location> [min node count] [max node count] [node size]"



$ip = AzQuery "network public-ip show -g $resourceGroupName -n $ipName" -q [ipAddress] -o tsv

ExecuteCommand "aks create standard $resourceGroupName $location $minNodeCount $maxNodeCount $nodeSize"

ExecuteCommand "aks credentials get $resourceGroupName"

ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks nginx install"
ExecuteCommand "aks nginx install `"masterdata`""
ExecuteCommand "aks nginx install `"dme`""
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"