param($subCommand)

$subCommands=@{
    "install" = "Install Monitoring with Prometheus and Grafana (Helm chart) (uses local config files).";
    "uninstall" = "Uninstall Monitoring with Prometheus and Grafana (Helm chart).";
}

SubMenu $PSScriptRoot $command $subCommand $subCommands