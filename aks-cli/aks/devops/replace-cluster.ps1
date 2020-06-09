# TODO: Refactor

WriteAndSetUsage "aks devops replace-cluster"

Write-Info "Azure DevOps: Replacing service-connection, environment and running pipelines"

if (AreYouSure)
{
    aks devops service-connection replace
    aks devops envionment replace-all
    aks devops pipeline deploy
}