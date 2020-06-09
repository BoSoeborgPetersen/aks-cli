WriteAndSetUsage "aks cert-manager upgrades"

CheckCurrentCluster

Write-Info "Show Certificate Manager upgradable versions"

HelmQuery "search repo jetstack/cert-manager"