$usage = Write-Usage "aks node-autoscaler disable"

VerifyCurrentCluster $usage

Write-Info ("Disable node autoscaler for current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az aks update -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) --disable-cluster-autoscaler $debugString")