WriteAndSetUsage "aks current"

CheckCurrentCluster

Write-Info "Current AKS cluster"

ExecuteCommand "kubectl config current-context"