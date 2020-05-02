# TODO: REWRITE!!!
# BUG: Problem observed when the dns name of public IP that the new endpoint points to has the dns name of the old IP that the old endpoint is pointing to. Replacing endpont instead of adding should fix it.

WriteAndSetUsage "aks traffic-manager redirect-all"

# Step 1: Choose source cluster
Write-Info "Choose source AKS cluster"
$sourceCluster = ChooseClusterMenu

# Step 2: Choose target cluster
Write-Info "Choose target AKS cluster"
$targetCluster = ChooseClusterMenu

Write-Info "Redirect all Traffic Managers from '$($sourceCluster.name)' to '$($targetCluster.name)'"

# Step 5: Find all traffic managers pointing to the Public IP resource of the source cluster.
$subscriptionId = GetCurrentSubscription
$sourceResourceGroup = $sourceCluster.resourceGroup
$sourcePublicIpName = ClusterToIpAddressName $sourceCluster.name
# $sourcePublicIpName = "$($sourceCluster.resourceGroup)-ip"
$sourcePublicIpId = "/subscriptions/$subscriptionId/resourceGroups/$sourceResourceGroup/providers/Microsoft.Network/publicIPAddresses/$sourcePublicIpName"
$trafficManagers = AzQuery "network traffic-manager profile list --query `"[?endpoints[].targetResourceId==$sourcePublicIpId]`"" | ConvertFrom-Json

# Step 6: Update Traffic Managers to point to the Public IP resource of the target cluster.
if (AreYouSure)
{
    $targetResourceGroup = $targetCluster.resourceGroup
    $targetPublicIpName = ClusterToIpAddressName $targetCluster.name
    $targetPublicIpId = "/subscriptions/$subscriptionId/resourceGroups/$targetResourceGroup/providers/Microsoft.Network/publicIPAddresses/$targetPublicIpName"
    foreach($trafficManager in $trafficManagers)
    {
        AzCommand "network traffic-manager endpoint delete -g $($trafficManager.resourceGroup) --profile-name $($trafficManager.name) -n '$($trafficManager.endpoints[0].name)' --type azureEndpoints"
        AzCommand "network traffic-manager endpoint create -g $($trafficManager.resourceGroup) --profile-name $($trafficManager.name) -n 'AKS' --type azureEndpoints --target-resource-id $targetPublicIpId"
    }
}