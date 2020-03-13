$usage = Write-Usage "aks analytics install"

VerifyCurrentCluster $usage

$analyticsName = ResourceGroupToAnalyticsName $selectedCluster.ResourceGroup

Write-Info ("Installing Log Analytics '$analyticsName' for current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az resource create --resource-type Microsoft.OperationalInsights/workspaces -g $($selectedCluster.ResourceGroup) -n $analyticsName -l $($selectedCluster.Location) -p '{\`"sku\`":\`"\`"}' $debugString")
$workspaceId = ExecuteQuery ("az resource show -g $($selectedCluster.ResourceGroup) -n $analyticsName --resource-type Microsoft.OperationalInsights/workspaces --query '[id]' -o tsv $debugString")
ExecuteCommand ("az aks enable-addons -a monitoring -g $($selectedCluster.ResourceGroup) -n $($selectedCluster.Name) --workspace-resource-id $workspaceId $debugString")