param($min, $max)

WriteAndSetUsage "aks node-autoscaler refresh [min] [max]"

CheckCurrentCluster
CheckNumberRange ([ref]$min) "min" -min 2 -max 100 -default 2
CheckNumberRange ([ref]$max) "max" -min 2 -max 100 -default 4

Write-Info "Refresh (disable, then enable) node autoscaler"

ExecuteCommand "aks node-autoscaler disable $debugString"
ExecuteCommand "aks node-autoscaler add $min $max $debugString"