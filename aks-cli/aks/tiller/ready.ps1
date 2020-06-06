WriteAndSetUsage "aks tiller ready"

CheckCurrentCluster

Write-Info "Check if Tiller (Helm server-side) is ready"

KubectlCommand "get deploy tiller-deploy -n kube-system -o jsonpath='{.items[0].status.conditions[0].status}'"