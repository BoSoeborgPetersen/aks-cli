WriteAndSetUsage "aks tiller upgrade"

CheckCurrentCluster

Write-Info "Upgrading Tiller (Helm server-side)"

Helm2Command "init --upgrade"