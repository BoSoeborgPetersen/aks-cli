param($name, $approver = "[Identity]\Contributors")

WriteAndSetUsage "aks devops environment-checks add" ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Creating Environment"

$id = AzDevOpsEnvironmentId $name
$approverId = AzDevOpsCommand "security group list" -q "graphGroups[?principalName=='$approver'].originId" -o tsv

$arguments = @{
    type = @{
        name = "Approval"
    }
    settings = @{
        approvers = @( 
            @{
                id = $approverId
            }
        )
        requesterCannotBeApprover = $false
    }
    resource = @{
        type = "environment"
        id = $id
        name = $name
    }
    timeout = 43200
}

$filepath = SaveTempFile $arguments
AzDevOpsInvokeCommand -a PipelinesChecks -r configurations -m POST -f $filepath
DeleteTempFile $filepath

# ADD:
# POST https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations