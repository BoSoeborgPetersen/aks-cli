# TODO: Not working.
# TODO: Refactor
# BUG: Problem observed when the dns name of public IP that the new endpoint points to has the dns name of the old IP that the old endpoint is pointing to. Replacing endpont instead of adding should fix it.

$usage = Write-Usage "aks traffic-manager redirect-all"

VerifyCurrentSubscription $usage

# Step 1: Choose source cluster
Clear-Host
Write-Info "Choose source AKS cluster"
$sourceCluster = ChooseAksCluster

# Step 2: Choose target cluster
Clear-Host
Write-Info "Choose target AKS cluster"
$targetCluster = ChooseAksCluster

Clear-Host
Write-Info "Redirect all Traffic Managers from '$($sourceCluster.name)' to '$($targetCluster.name)'"

# Step 5: Find all traffic managers pointing to the Public IP resource of the source cluster.
$subscriptionId = $GlobalCurrentSubscription.id
$sourceResourceGroup = $sourceCluster.resourceGroup
$sourcePublicIpName = ClusterToIpAddressName $sourceCluster.name
# $sourcePublicIpName = "$($sourceCluster.resourceGroup)-ip"
$sourcePublicIpId = "/subscriptions/$subscriptionId/resourceGroups/$sourceResourceGroup/providers/Microsoft.Network/publicIPAddresses/$sourcePublicIpName"
$trafficManagers = ExecuteQuery "az network traffic-manager profile list --query `"[?contains(endpoints[].targetResourceId, '$sourcePublicIpId')]`" $debugString" | ConvertFrom-Json

# Step 6: Update Traffic Managers to point to the Public IP resource of the target cluster.
if (AreYouSure)
{
    $targetResourceGroup = $targetCluster.resourceGroup
    $targetPublicIpName = ClusterToIpAddressName $targetCluster.name
    $targetPublicIpId = "/subscriptions/$subscriptionId/resourceGroups/$targetResourceGroup/providers/Microsoft.Network/publicIPAddresses/$targetPublicIpName"
    foreach($trafficManager in $trafficManagers)
    {
        ExecuteCommand "az network traffic-manager endpoint delete -g $($trafficManager.resourceGroup) --profile-name $($trafficManager.name) -n '$($trafficManager.endpoints[0].name)' --type azureEndpoints $debugString"
        ExecuteCommand "az network traffic-manager endpoint create -g $($trafficManager.resourceGroup) --profile-name $($trafficManager.name) -n 'AKS' --type azureEndpoints --target-resource-id $targetPublicIpId $debugString"
    }
}