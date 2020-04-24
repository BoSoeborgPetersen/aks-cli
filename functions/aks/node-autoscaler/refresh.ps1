param($min, $max)

WriteAndSetUsage "aks node-autoscaler refresh [min] [max]"

VerifyCurrentCluster
SetDefaultIfEmpty ([ref]$min) 2
SetDefaultIfEmpty ([ref]$max) 4

ValidateNumberRange ([ref]$min) "min" 2 100
ValidateNumberRange ([ref]$max) "max" 2 100

Write-Info "Refresh (disable, then enable) node autoscaler"

ExecuteCommand "aks node-autoscaler disable $debugString"
ExecuteCommand "aks node-autoscaler add $min $max $debugString"