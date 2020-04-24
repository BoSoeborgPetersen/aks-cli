# TODO: Integrate into "aks switch cluster", as "aks switch cluster -resourceGroup <resource group>".
param($resourceGroup)

WriteAndSetUsage "aks credentials get <resource group>"

CheckVariable $resourceGroup "resource group"

$cluster = ResourceGroupToClusterName $resourceGroup

Write-Info "Get AKS cluster credentials"

ExecuteCommand "az aks get-credentials -g $resourceGroup -n $cluster $debugString"