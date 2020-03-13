$usage = Write-Usage "aks tiller wait"

VerifyCurrentCluster $usage

Write-Info ("Wait for Tiller (Helm server-side) to be ready in current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("kubectl rollout status deployment/tiller-deploy -n kube-system $kubeDebugString")