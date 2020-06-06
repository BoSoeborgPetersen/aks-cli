WriteAndSetUsage "aks identity get"

CheckCurrentCluster

Write-Info "Get current AKS cluster managed identity"

AzAksCurrentCommand "show" -q identityProfile.kubeletidentity.clientId -o tsv