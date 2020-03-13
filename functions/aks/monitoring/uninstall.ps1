$usage = Write-Usage "aks monitoring uninstall"

VerifyCurrentCluster $usage

Write-Info ("Uninstalling Monitoring (Prometheus & Grafana) from current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "helm delete grafana --purge $debugString"
ExecuteCommand "helm delete prometheus --purge $debugString"