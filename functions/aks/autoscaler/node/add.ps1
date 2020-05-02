param($min, $max)

WriteAndSetUsage "aks autoscaler node add [min] [max]"

CheckCurrentCluster
CheckNumberRange ([ref]$min) "min" -min 2 -max 100 -default 2
CheckNumberRange ([ref]$max) "max" -min 2 -max 100 -default 4

Write-Info "Add node autoscaler"

AzAksCurrentCommand "update --enable-cluster-autoscaler --min-count $min --max-count $max"