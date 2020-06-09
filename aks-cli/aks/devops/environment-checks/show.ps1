param($name)

WriteAndSetUsage "aks devops environment-checks show" ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Showing Environment Check"

$id = AzDevOpsEnvironmentId $name

AzDevOpsInvokeQuery -a PipelinesChecks -r configurations -p "resourceType=environment resourceId=$id"

# LIST:
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations?resourceType=environment&resourceId=234

# SHOW:
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations/233