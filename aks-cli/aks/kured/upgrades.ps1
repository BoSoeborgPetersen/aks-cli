WriteAndSetUsage "aks kured upgrades"

CheckCurrentCluster

Write-Info "Show Kured upgradable versions"

HelmQuery "search repo kured/kured"

defaultBackend.autoscaling.minReplicas