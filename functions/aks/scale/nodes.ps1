param($count)

WriteAndSetUsage "aks scale nodes <count>"

CheckCurrentCluster
CheckNumberRange ([ref]$count) "count" -min 2 -max 100

Write-Info "Scaling cluster to '$count' nodes"

ExecuteCommand "az aks scale -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) -c $count $debugString"