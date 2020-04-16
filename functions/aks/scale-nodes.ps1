param($nodeCount)

$usage = Write-Usage "aks scale-nodes <node count>"

VerifyCurrentCluster $usage
ValidateNumberRange $usage ([ref]$nodeCount) "node count" 2 100

Write-Info ("Scaling number of nodes to '$nodeCount', for cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az aks scale -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) -c $nodeCount $debugString")