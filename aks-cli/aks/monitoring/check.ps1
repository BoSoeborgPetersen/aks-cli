# TODO: Test
WriteAndSetUsage

CheckCurrentCluster

Write-Info "Checking Monitoring"

Write-Info "Checking Prometheus Helm Chart"
HelmCheck prometheus -n monitoring
Write-Info "Checking Grafana Helm Chart"
HelmCheck grafana -n monitoring