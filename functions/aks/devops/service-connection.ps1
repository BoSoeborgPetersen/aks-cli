param($subSubCommand)

$subSubCommands=@{
    "show" = "Show a Azure DevOps Service-Connection.";
    "create" = "Create Azure DevOps Service-Connection.";
    "replace" = "Replace Azure DevOps Service-Connection.";
    "delete" = "Delete Azure DevOps Service-Connection.";
}

SubSubMenu $PSScriptRoot $subCommand $subSubCommand $subSubCommands