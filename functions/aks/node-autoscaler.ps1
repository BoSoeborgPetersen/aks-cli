param($subCommand)

$subCommands=@{
    "add" = "Add AKS cluster node autoscaler."
    "refresh" = "Refresh AKS cluster node autoscaler."
    "disable" = "Disable  AKS cluster node autoscaler."
}

SubMenu $PSScriptRoot $command $subCommand $subCommands