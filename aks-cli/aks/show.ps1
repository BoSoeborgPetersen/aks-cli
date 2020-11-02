param($query)

WriteAndSetUsage ([ordered]@{
    "[query]" = "Azure CLI JsonPath Query"
})

CheckCurrentCluster

Write-Info "Show AKS cluster information"

AzAksCurrentCommand "show" -q $query