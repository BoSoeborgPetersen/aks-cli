WriteAndSetUsage "aks autoscaler node check"

CheckCurrentCluster

Write-Info "Checking node autoscaler"
AzCheckNodeAutoscaler
Write-Info "Node autoscaler exists"