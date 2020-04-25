param($min, $max)

WriteAndSetUsage "aks autoscaler node refresh [min] [max]"

CheckCurrentCluster
CheckNumberRange ([ref]$min) "min" -min 2 -max 100 -default 2
CheckNumberRange ([ref]$max) "max" -min 2 -max 100 -default 4

Write-Info "Refresh (disable, then enable) node autoscaler"

ExecuteCommand "aks autoscaler node disable $debugString"
ExecuteCommand "aks autoscaler node add $min $max $debugString"