param($minNodeCount, $maxNodeCount)

$usage = Write-Usage "aks node-autoscaler add <min node count> <max node count>"

SetDefaultIfEmpty ([ref]$minNodeCount) 2
SetDefaultIfEmpty ([ref]$maxNodeCount) 4

ValidateNumberRange $usage ([ref]$minNodeCount) "min node count" 2 100
ValidateNumberRange $usage ([ref]$maxNodeCount) "max node count" 2 100

VerifyCurrentCluster $usage

Write-Info ("Add node autoscaler (min count: $minNodeCount, max count: $maxNodeCount) to current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az aks update -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) --enable-cluster-autoscaler --min-count $minNodeCount --max-count $maxNodeCount $debugString")