param($min, $max)

$usage = Write-Usage "aks node-autoscaler add [min] [max]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$min) 2
SetDefaultIfEmpty ([ref]$max) 4

ValidateNumberRange $usage ([ref]$min) "min" 2 100
ValidateNumberRange $usage ([ref]$max) "max" 2 100

Write-Info "Add node autoscaler"

ExecuteCommand "az aks update -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --enable-cluster-autoscaler --min-count $min --max-count $max $debugString"