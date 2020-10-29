WriteAndSetUsage

CheckCurrentCluster
$resourceGroup = CurrentClusterResourceGroup

$insights = InsightsName -resourceGroup $resourceGroup

Write-Info "Uninstalling Operational Insights '$insights'"

if (AreYouSure)
{
    AzAksCurrentCommand "disable-addons -a monitoring"
    AzCommand "monitor log-analytics workspace delete -g $resourceGroup -n $insights"
}