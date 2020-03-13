param($subCommand)

$subCommands=@{
    "standard" = "Create AKS cluster (does not switch to it).";
    "windows" = "Create AKS cluster with Windows node pool (does not switch to it).";
}

SubMenu $PSScriptRoot $command $subCommand $subCommands