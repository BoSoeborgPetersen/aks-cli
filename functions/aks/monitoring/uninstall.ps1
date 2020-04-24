WriteAndSetUsage "aks monitoring uninstall"

VerifyCurrentCluster

Write-Info "Uninstalling Monitoring (Prometheus & Grafana)"

if (AreYouSure)
{
    ExecuteCommand "helm3 uninstall grafana --namespace monitoring $debugString"
    ExecuteCommand "helm3 uninstall prometheus --namespace monitoring $debugString"
}