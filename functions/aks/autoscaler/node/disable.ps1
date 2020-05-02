WriteAndSetUsage "aks autoscaler node disable"

CheckCurrentCluster

Write-Info "Disable node autoscaler"

AzAksCurrentCommand "update --disable-cluster-autoscaler"