param($query)

WriteAndSetUsage ([ordered]@{
    "[query]" = "Azure CLI JsonPath Query"
})

Write-Info "List Service Connections"

AzDevOpsCommand "service-endpoint list" -q $query