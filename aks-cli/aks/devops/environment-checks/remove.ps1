param($name)

WriteAndSetUsage "aks devops environment-checks remove" ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Removing Environment Check"

$environmentId = AzDevOpsEnvironmentId $name
CheckVariable $environmentId "environment id"
$checkId = AzDevOpsInvokeQuery -a PipelinesChecks -r configurations -p "resourceType=environment resourceId=$environmentId" -q "value[0].id" -o tsv
CheckVariable $checkId "environment check id"

AzDevOpsInvokeCommand -a PipelinesChecks -r configurations -p "id=$checkId" -m DELETE

# DELETE:
# DELETE https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations/{id}