$orgName = GetDevOpsOrganizationName
$teamName = GetDevOpsTeamName
az devops configure --defaults organization=https://dev.azure.com/$orgName/ project=$teamName

SubMenu @{
    "environment" = "Azure DevOps Environment operations."
    "pipeline" = "Azure DevOps Pipeline operations."
    "replace-cluster" = "<missing?>"
    "service-connection" = "Azure DevOps Service-Connection operations."
}