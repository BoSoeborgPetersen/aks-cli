$usage = Write-Usage "aks tiller ready"

VerifyCurrentCluster $usage

Write-Info "Check if Tiller (Helm server-side) is ready"

ExecuteCommand "kubectl get deploy tiller-deploy -n kube-system -o jsonpath='{.items[0].status.conditions[0].status}' $kubeDebugString"