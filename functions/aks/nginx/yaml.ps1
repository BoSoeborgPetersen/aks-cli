WriteAndSetUsage "aks nginx yaml"

CheckCurrentCluster

Write-Info "Edit manifest config file (yaml) used for installing Nginx"

ExecuteCommand "nano $PSScriptRoot/config/nginx-config.yaml"