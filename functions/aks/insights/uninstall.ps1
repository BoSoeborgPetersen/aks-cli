WriteAndSetUsage "aks insights uninstall"

CheckCurrentCluster

$insights = ResourceGroupToInsightsName $GlobalCurrentCluster.ResourceGroup

Write-Info "Uninstalling Operational Insights '$insights'"

if (AreYouSure)
{
    ExecuteCommand "az aks disable-addons -a monitoring -g $($GlobalCurrentCluster.ResourceGroup) -n $($GlobalCurrentCluster.Name) $debugString"
    ExecuteCommand "az resource delete --resource-type Microsoft.OperationalInsights/workspaces -g $($GlobalCurrentCluster.ResourceGroup) -n $insights $debugString"
}