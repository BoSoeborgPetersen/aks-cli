param($name)

$teamName = GetDevOpsTeamName
az devops invoke --area environments --resource environments --route-parameters project=$teamName --http-method GET --api-version 6.0-preview --query "value[?name==$name]"