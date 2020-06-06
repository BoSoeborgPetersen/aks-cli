param($environmentName)

WriteAndSetUsage "aks devops environment delete <environment name>"

CheckVariable $environmentName "environment name"

$teamName = GetDevOpsTeamName
$environmentId = AzQuery "devops invoke --area environments --resource environments --route-parameters project=$teamName --http-method GET --api-version 6.0-preview" -q "`"value[?name==$environmentName].id`"" -o tsv
AzCommand "devops invoke --area environments --resource environments --route-parameters project=$teamName environmentId=$environmentId --http-method DELETE --api-version 6.0-preview"