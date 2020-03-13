param($minNodeCount, $maxNodeCount)

$usage = Write-Usage "aks node-autoscaler refresh <min node count> <max node count>"

VerifyVariable $usage $minNodeCount "min node count"
VerifyVariable $usage $maxNodeCount "max node count"

Write-Info ("Refresh (disable, then enable) node autoscaler for current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "aks node-autoscaler disable $debugString"
ExecuteCommand "aks node-autoscaler add $minNodeCount $maxNodeCount $debugString"