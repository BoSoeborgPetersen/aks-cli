WriteAndSetUsage "aks nginx yaml"

VerifyCurrentCluster

Write-Info "Edit manifest config file (yaml) used for installing Nginx-Ingress"

ExecuteCommand "nano $PSScriptRoot/config/nginx-config.yaml"