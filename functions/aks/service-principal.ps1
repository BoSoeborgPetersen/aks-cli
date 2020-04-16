param($subCommand)

$subCommands=@{
    "create" = "Create AKS cluster Service Principal."
    "get" = "Get AKS cluster Service Principal ID."
    "replace" = "Replace the AKS cluster Service Principal."
}

SubMenu $PSScriptRoot $command $subCommand $subCommands