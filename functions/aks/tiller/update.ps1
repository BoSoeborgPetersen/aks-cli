$usage = Write-Usage "aks tiller update"

VerifyCurrentCluster $usage

Write-Info ("Updating Tiller (Helm server-side) on current cluster '$($selectedCluster.Name)'")

ExecuteCommand ("helm init --upgrade $debugString")