param($resourceGroupName)

$usage = Write-Usage "aks credentials get <resource group name>"

VerifyVariable $usage $resourceGroupName "resource group name"

$clusterName = ResourceGroupToClusterName $resourceGroupName

Write-Info ("Get AKS cluster '$($selectedCluster.Name)' credentials")

ExecuteCommand ("az aks get-credentials -g $resourceGroupName -n $clusterName $debugString")