param($subCommand)

$subCommands=@{
    "install" = "Create Azure Log Analytics Workspace and attach it to the AKS cluster.";
    "uninstall" = "Detach Azure Log Analytics Workspace from AKS cluster, and delete it.";
}

SubMenu $PSScriptRoot $command $subCommand $subCommands