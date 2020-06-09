param($name)

WriteAndSetUsage "aks devops environment-checks check" ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

$environmentId = AzDevOpsEnvironmentId $name
Write-Info "Checking DevOps Environment Check"
AzDevOpsInvokeCheck PipelinesChecks configurations "resourceType=environment resourceId=$environmentId" "value[?resource.name=='$name'].resource.name" -exit
Write-Info "DevOps Environment Check exists"