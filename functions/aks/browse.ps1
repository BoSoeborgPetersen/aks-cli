$usage = Write-Usage "aks browse"

VerifyCurrentCluster $usage

Write-Info ("Open Kubernetes Dashboard connection for cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az aks browse -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) $debugString")