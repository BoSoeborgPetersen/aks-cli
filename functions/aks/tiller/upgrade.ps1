WriteAndSetUsage "aks tiller upgrade"

CheckCurrentCluster

Write-Info "Upgrading Tiller (Helm server-side)"

ExecuteCommand "helm init --upgrade $debugString"