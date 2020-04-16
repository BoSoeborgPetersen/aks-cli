$orgName = GetDevOpsOrganizationName
$teamName = GetDevOpsTeamName
az devops configure --defaults organization=https://dev.azure.com/$orgName/ project=$teamName

SubMenu @{
    "service-connection" = "Azure DevOps Service-Connection operations."
    "pipeline" = "Azure DevOps Pipeline operations."
    "environment" = "Azure DevOps Environment operations."
    "replace-cluster" = "<missing?>"
}