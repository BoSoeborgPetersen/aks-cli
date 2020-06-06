WriteAndSetUsage "aks tiller upgrade"

CheckCurrentCluster

Write-Info "Upgrading Tiller (Helm server-side)"

HelmCommand "init --upgrade"