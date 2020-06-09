# TODO: Test
param($resourceGroup, $globalSubscription)

WriteAndSetUsage "aks registry check" ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<globalSubscription>" = "Azure Subscription for Azure Container Registry"
})

CheckVariable $resourceGroup "resource group"
CheckVariable $globalSubscription "global subscription"
$globalResourceGroup = GlobalResourceGroupName -resourceGroup $resourceGroup
AzCheckResourceGroup $globalResourceGroup $globalSubscription
$registry = RegistryName -resourceGroup $resourceGroup

Write-Info "Checking Registry"
AzCheckContainerRegistry $registry $globalSubscription
Write-Info "Registry exists"