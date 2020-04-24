WriteAndSetUsage "aks insights install"

CheckCurrentCluster

$insights = ResourceGroupToInsightsName $GlobalCurrentCluster.ResourceGroup

Write-Info "Installing Operational Insights '$insights'"

# TODO: Try to remove -l and see if it still works, because of the resource group being specified.
# TODO: Clean up '-p'.
ExecuteCommand "az resource create --resource-type Microsoft.OperationalInsights/workspaces -g $($GlobalCurrentCluster.ResourceGroup) -n $insights -l $($GlobalCurrentCluster.Location) -p '{\`"sku\`":\`"\`"}' $debugString"
$id = ExecuteQuery "az resource show -g $($GlobalCurrentCluster.ResourceGroup) -n $insights --resource-type Microsoft.OperationalInsights/workspaces --query id -o tsv $debugString"
ExecuteCommand "az aks enable-addons -a monitoring -g $($GlobalCurrentCluster.ResourceGroup) -n $($GlobalCurrentCluster.Name) --workspace-resource-id $id $debugString"