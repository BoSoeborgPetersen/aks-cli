param($count)

WriteAndSetUsage ([ordered]@{
    "<count>" = "Number of nodes (VMs)"
})

CheckCurrentCluster
CheckNumberRange $count "count" -min 2 -max 100

Write-Info "Scaling cluster to '$count' nodes"

AzAksCurrentCommand "scale -c $count"