$usage = Write-Usage "aks current"

VerifyCurrentCluster $usage

Write-Info "Current AKS cluster"

ExecuteCommand "kubectl config current-context"