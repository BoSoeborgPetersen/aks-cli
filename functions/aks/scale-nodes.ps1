param($count)

$usage = Write-Usage "aks scale-nodes <count>"

VerifyCurrentCluster $usage
ValidateNumberRange $usage ([ref]$count) "count" 2 100

Write-Info "Scaling cluster to '$count' nodes"

ExecuteCommand "az aks scale -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) -c $count $debugString"