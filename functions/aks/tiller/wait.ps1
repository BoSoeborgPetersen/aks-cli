WriteAndSetUsage "aks tiller wait"

CheckCurrentCluster

Write-Info "Wait for Tiller (Helm server-side) to be ready"

ExecuteCommand "kubectl rollout status deployment/tiller-deploy -n kube-system $kubeDebugString"