WriteAndSetUsage "aks current"

VerifyCurrentCluster

Write-Info "Current AKS cluster"

ExecuteCommand "kubectl config current-context"