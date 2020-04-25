# TODO: Refactor

Write-Info "Azure DevOps: Replacing service-connection, environment and running pipelines."

if (AreYouSure)
{
    az devops service-connection replace
    az devops envionment replace-all
    az devops pipeline deploy
}