param($resourceGroup)

WriteAndSetUsage "aks credentials get <resource group>"

VerifyCurrentCluster
VerifyVariable $resourceGroup "resource group"

$cluster = ResourceGroupToClusterName $resourceGroup

Write-Info "Get current AKS cluster credentials"

ExecuteCommand "az aks get-credentials -g $resourceGroup -n $cluster $debugString"