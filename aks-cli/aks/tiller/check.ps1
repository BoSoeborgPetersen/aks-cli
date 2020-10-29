WriteAndSetUsage

CheckCurrentCluster

Write-Info "Checking Tiller (Helm server-side)"

Write-Info "Checking serviceaccount"
KubectlCheck serviceaccount tiller -namespace kube-system
Write-Info "Serviceaccount exists"

Write-Info "Checking clusterrolebinding"
KubectlCheck clusterrolebinding tiller
Write-Info "Clusterrolebinding exists"

Write-Info "Check if Tiller (Helm server-side) is ready"
KubectlCommand "get deploy tiller-deploy" -n kube-system -j '{.items[0].status.conditions[0].status}'
Write-Info "Tiller (Helm server-side) is ready"

Write-Info "Tiller (Helm server-side) exists"