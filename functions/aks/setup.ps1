param($subCommand)

$subCommands=@{
    "standard" = "Create and configure Kubernetes cluster, with Nginx, Cert-Manager and Log Analytics.";
    "communicate" = "Create and configure Kubernetes cluster (for Communicate Team), with Nginx, Cert-Manager and Log Analytics.";
    "windows" = "Create and configure Kubernetes cluster, with Windows node pool, Prometheus, Grafana and Log Analytics.";
}

SubMenu $PSScriptRoot $command $subCommand $subCommands