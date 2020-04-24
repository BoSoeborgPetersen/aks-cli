WriteAndSetUsage "aks analytics install"

VerifyCurrentCluster

$analytics = ResourceGroupToAnalyticsName $GlobalCurrentCluster.ResourceGroup

Write-Info "Installing Log Analytics '$analytics'"

# TODO: Try to remove -l and see if it still works, because of the resource group being specified.
ExecuteCommand "az resource create --resource-type Microsoft.OperationalInsights/workspaces -g $($GlobalCurrentCluster.ResourceGroup) -n $analytics -l $($GlobalCurrentCluster.Location) -p '{\`"sku\`":\`"\`"}' $debugString"
$id = ExecuteQuery "az resource show -g $($GlobalCurrentCluster.ResourceGroup) -n $analytics --resource-type Microsoft.OperationalInsights/workspaces --query '[id]' -o tsv $debugString"
ExecuteCommand "az aks enable-addons -a monitoring -g $($GlobalCurrentCluster.ResourceGroup) -n $($GlobalCurrentCluster.Name) --workspace-resource-id $id $debugString"