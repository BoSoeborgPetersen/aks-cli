# TODO: Add Approval/Check (e.g. '[Identity]\Contributors')
param($environmentName)

WriteAndSetUsage "aks devops environment create <environment name>"

CheckVariable $environmentName "environment name"

$teamName = GetDevOpsTeamName

$arguments=@{
    "name" = "$environmentName"
}
$arguments | ConvertTo-Json | Out-File -FilePath ~/azure-devops-environment-create.json
ExecuteCommand ("az devops invoke --area environments --resource environments --route-parameters project=$teamName --http-method POST --api-version 6.0-preview --in-file ~/azure-devops-environment-create.json $debugString")
Remove-Item ~/azure-devops-environment-create.json