param($subCommand)

$orgName = GetDevOpsOrganizationName
$teamName = GetDevOpsTeamName
az devops configure --defaults organization=https://dev.azure.com/$orgName/ project=$teamName

$subCommands=@{
    "service-connection" = "Azure DevOps Service-Connection operations."
    "pipeline" = "Azure DevOps Pipeline operations."
    "environment" = "Azure DevOps Environment operations."
    "replace-cluster" = "<missing?>"
}

SubMenu $PSScriptRoot $command $subCommand $subCommands