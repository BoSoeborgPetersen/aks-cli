$usage = Write-Usage "aks nginx yaml"

VerifyCurrentCluster $usage

Write-Info ("Edit manifest config file (yaml) used for installing Nginx-Ingress on current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "nano $PSScriptRoot/config/nginx-config.yaml"