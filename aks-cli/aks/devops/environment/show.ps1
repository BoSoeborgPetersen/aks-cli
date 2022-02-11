param($name)

WriteAndSetUsage ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Showing Environment"

# AzDevOpsInvokeQuery -a environments -r environments -q "value[?name=='$name']"
$id = $name
AzDevOpsInvokeQuery -a environments -r environments -p "environmentId=$id"