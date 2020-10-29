param($min = 2, $max = 4)

WriteAndSetUsage ([ordered]@{
    "[min]" = AzureVmMinNodeCountDescription
    "[max]" = AzureVmMaxNodeCountDescription
})

CheckCurrentCluster
CheckNumberRange $min "min" -min 2 -max 100
CheckNumberRange $max "max" -min 2 -max 100

Write-Info "Enable node autoscaler"

AzAksCurrentCommand "update --enable-cluster-autoscaler --min-count $min --max-count $max"