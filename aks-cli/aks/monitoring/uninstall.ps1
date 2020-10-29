WriteAndSetUsage

CheckCurrentCluster

Write-Info "Uninstalling Monitoring (Prometheus & Grafana)"

if (AreYouSure)
{
    HelmCommand "uninstall grafana" -n monitoring
    HelmCommand "uninstall prometheus" -n monitoring
}