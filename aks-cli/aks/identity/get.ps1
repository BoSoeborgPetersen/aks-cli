WriteAndSetUsage

CheckCurrentCluster

Write-Info "Get current AKS cluster managed identity (system assigned)"
AzAksCurrentCommand "show" -q identity.principalId -o tsv

Write-Info "Get current AKS cluster managed identity (user assigned)"
AzAksCurrentCommand "show" -q identityProfile.kubeletidentity.clientId -o tsv