WriteAndSetUsage "aks tiller upgrade"

VerifyCurrentCluster

Write-Info "Upgrading Tiller (Helm server-side)"

ExecuteCommand "helm init --upgrade $debugString"