WriteAndSetUsage "aks insights install"

CheckCurrentCluster
$resourceGroup = CurrentClusterResourceGroup

$insights = InsightsName -resourceGroup $resourceGroup

Write-Info "Installing Operational Insights '$insights'"

AzCommand "monitor log-analytics workspace create -g $resourceGroup -n $insights"
AzCommand "monitor log-analytics workspace update -g $resourceGroup -n $insights --set sku.name=free --set retentionInDays=7"
$id = AzQuery "monitor log-analytics workspace show -g $resourceGroup -n $insights" -q id -o tsv
AzAksCurrentCommand "enable-addons -a monitoring --workspace-resource-id $id"