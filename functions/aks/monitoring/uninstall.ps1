WriteAndSetUsage "aks monitoring uninstall"

CheckCurrentCluster

Write-Info "Uninstalling Monitoring (Prometheus & Grafana)"

if (AreYouSure)
{
    Helm3Command "uninstall grafana --namespace monitoring"
    Helm3Command "uninstall prometheus --namespace monitoring"
}