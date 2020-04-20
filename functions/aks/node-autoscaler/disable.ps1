$usage = Write-Usage "aks node-autoscaler disable"

VerifyCurrentCluster $usage

Write-Info "Disable node autoscaler"

ExecuteCommand "az aks update -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --disable-cluster-autoscaler $debugString"