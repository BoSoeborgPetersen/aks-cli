# TODO: Rewrite
# BUG: Problem observed when the dns name of public IP that the new endpoint points to has the dns name of the old IP that the old endpoint is pointing to. Replacing endpont instead of adding should fix it.

WriteAndSetUsage

# Step 1: Choose source cluster
Write-Info "Choose source AKS cluster"
$sourceCluster = ClusterMenu

# Step 2: Choose target cluster
Write-Info "Choose target AKS cluster"
$targetCluster = ClusterMenu

Write-Info "Redirect all Traffic Managers from '$($sourceCluster.name)' to '$($targetCluster.name)'"

# Step 5: Find all traffic managers pointing to the Public IP resource of the source cluster.
$subscriptionId = CurrentSubscription
$sourceResourceGroup = $sourceCluster.resourceGroup
$sourcePublicIp = PublicIpName -cluster $sourceCluster.name
# $sourcePublicIp = "$($sourceCluster.resourceGroup)-ip"
$sourcePublicIpId = "/subscriptions/$subscriptionId/resourceGroups/$sourceResourceGroup/providers/Microsoft.Network/publicIPAddresses/$sourcePublicIp"
$trafficManagers = AzQuery "network traffic-manager profile list" -q "[?endpoints[].targetResourceId==$sourcePublicIpId]" | ConvertFrom-Json

# Step 6: Update Traffic Managers to point to the Public IP resource of the target cluster.
if (AreYouSure)
{
    $targetResourceGroup = $targetCluster.resourceGroup
    $targetPublicIp = PublicIpName -cluster $targetCluster.name
    $targetPublicIpId = "/subscriptions/$subscriptionId/resourceGroups/$targetResourceGroup/providers/Microsoft.Network/publicIPAddresses/$targetPublicIp"
    foreach($trafficManager in $trafficManagers)
    {
        AzCommand "network traffic-manager endpoint delete -g $($trafficManager.resourceGroup) --profile-name $($trafficManager.name) -n '$($trafficManager.endpoints[0].name)' --type azureEndpoints"
        AzCommand "network traffic-manager endpoint create -g $($trafficManager.resourceGroup) --profile-name $($trafficManager.name) -n 'AKS' --type azureEndpoints --target-resource-id $targetPublicIpId"
    }
}