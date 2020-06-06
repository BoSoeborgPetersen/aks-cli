WriteAndSetUsage "aks current"

CheckCurrentCluster

Write-Info "Current AKS cluster"

KubectlCommand "config current-context"