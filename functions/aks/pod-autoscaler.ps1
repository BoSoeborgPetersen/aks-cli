param($subCommand)

$subCommands=@{
    "add" = "Add Kubernetes deployment pod autoscaler.";
    "replace" = "Replace Kubernetes deployment pod autoscaler.";
    "remove" = "Remove Kubernetes deployment pod autoscaler.";
}

SubMenu $PSScriptRoot $command $subCommand $subCommands