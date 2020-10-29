param($name)

WriteAndSetUsage ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Checking DevOps Environment"
AzDevOpsInvokeCheck environments environments "value[?name=='$name'].name" -exit
Write-Info "DevOps Environment exists"