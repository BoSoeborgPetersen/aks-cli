$usage = Write-Usage "aks tiller upgrade"

VerifyCurrentCluster $usage

Write-Info ("Upgrading Tiller (Helm server-side) on current cluster '$($selectedCluster.Name)'")

ExecuteCommand ("helm init --upgrade $debugString")