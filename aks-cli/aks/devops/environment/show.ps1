param($name)

WriteAndSetUsage "aks devops environment show" ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Showing Environment"

AzDevOpsInvokeQuery -a environments -r environments -q "value[?name=='$name']"

# LIST:
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments

# SHOW:
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234