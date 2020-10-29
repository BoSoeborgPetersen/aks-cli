WriteAndSetUsage

CheckCurrentCluster

Write-Info "Get current AKS cluster service principal"

AzAksCurrentCommand "show" -q servicePrincipalProfile -o tsv