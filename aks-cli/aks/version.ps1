WriteAndSetUsage "aks version"

CheckCurrentCluster

Write-Info "Current AKS cluster version"

AzAksCurrentCommand "show" -q kubernetesVersion -o tsv