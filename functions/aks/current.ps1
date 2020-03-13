$usage = Write-Usage "aks current"

VerifyCurrentCluster $usage

Write-Info ("Current AKS cluster")

$selectedCluster.Name