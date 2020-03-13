param($environmentName)

$usage = Write-Usage "aks devops environment delete <environment name>"

VerifyVariable $usage $environmentName "environment name"

$teamName = GetDevOpsTeamName
$environmentId = ExecuteQuery ("az devops invoke --area environments --resource environments --route-parameters project=$teamName --http-method GET --api-version 6.0-preview --query `"value[?name=='$environmentName'].id`" -o tsv $debugString")
ExecuteCommand ("az devops invoke --area environments --resource environments --route-parameters project=$teamName environmentId=$environmentId --http-method DELETE --api-version 6.0-preview $debugString")