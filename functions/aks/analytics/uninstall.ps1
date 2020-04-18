$usage = Write-Usage "aks analytics uninstall"

VerifyCurrentCluster $usage

$analyticsName = ResourceGroupToAnalyticsName $selectedCluster.ResourceGroup

Write-Info ("Uninstalling Log Analytics '$analyticsName' for current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az aks disable-addons -a monitoring -g $($selectedCluster.ResourceGroup) -n $($selectedCluster.Name) $debugString")
ExecuteCommand ("az resource delete --resource-type Microsoft.OperationalInsights/workspaces -g $($selectedCluster.ResourceGroup) -n $analyticsName $debugString")