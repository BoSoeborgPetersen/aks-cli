param($name)

WriteAndSetUsage "aks devops environment-checks replace" ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Replacing Environment Check"

AksCommand devops environment-checks remove $name
AksCommand devops environment-checks add $name