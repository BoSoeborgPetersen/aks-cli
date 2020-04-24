WriteAndSetUsage "aks analytics uninstall"

VerifyCurrentCluster

$analytics = ResourceGroupToAnalyticsName $GlobalCurrentCluster.ResourceGroup

Write-Info "Uninstalling Log Analytics '$analytics'"

if (AreYouSure)
{
    ExecuteCommand "az aks disable-addons -a monitoring -g $($GlobalCurrentCluster.ResourceGroup) -n $($GlobalCurrentCluster.Name) $debugString"
    ExecuteCommand "az resource delete --resource-type Microsoft.OperationalInsights/workspaces -g $($GlobalCurrentCluster.ResourceGroup) -n $analytics $debugString"
}