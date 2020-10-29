param($min, $max)

WriteAndSetUsage ([ordered]@{
    "[min]" = AzureVmMinNodeCountDescription
    "[max]" = AzureVmMaxNodeCountDescription
})

Write-Info "Refresh (disable, then enable) node autoscaler"

AksCommand autoscaler node disable $debugString
AksCommand autoscaler node enable $min $max $debugString