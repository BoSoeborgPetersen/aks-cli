WriteAndSetUsage "aks monitoring uninstall"

CheckCurrentCluster

Write-Info "Uninstalling Monitoring (Prometheus & Grafana)"

if (AreYouSure)
{
    Helm3Command "uninstall grafana -n monitoring"
    Helm3Command "uninstall prometheus -n monitoring"
}