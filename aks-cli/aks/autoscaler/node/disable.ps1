WriteAndSetUsage

CheckCurrentCluster

Write-Info "Disable node autoscaler"

AzAksCurrentCommand "update --disable-cluster-autoscaler"