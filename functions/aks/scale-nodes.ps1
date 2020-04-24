param($count)

WriteAndSetUsage "aks scale-nodes <count>"

VerifyCurrentCluster
ValidateNumberRange ([ref]$count) "count" 2 100

Write-Info "Scaling cluster to '$count' nodes"

ExecuteCommand "az aks scale -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) -c $count $debugString"