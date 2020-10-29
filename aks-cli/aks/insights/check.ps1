WriteAndSetUsage

CheckCurrentCluster
$resourceGroup = CurrentClusterResourceGroup

$insights = InsightsName -resourceGroup $resourceGroup

Write-Info "Checking Operational Insights '$insights'"

Write-Info "Checking log-analytics workspace"
AzCheckInsights $resourceGroup $insights
Write-Info "Log-analytics workspace exists"

# LaterDo: Check that log-analytics workspace has free sku

Write-Info "Checking monitoring addon"
AzCheckMonitoringAddon
Write-Info "Monitoring addon exists"

Write-Info "Operational Insights '$insights' exists"