$usage = Write-Usage "aks tiller ready"

VerifyCurrentCluster $usage

Write-Info ("Check if Tiller (Helm server-side) is ready on current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("kubectl get deploy -o jsonpath='{.items[0].status.conditions[0].status}' $kubeDebugString")