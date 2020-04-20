$usage = Write-Usage "aks tiller upgrade"

VerifyCurrentCluster $usage

Write-Info "Upgrading Tiller (Helm server-side)"

ExecuteCommand "helm init --upgrade $debugString"