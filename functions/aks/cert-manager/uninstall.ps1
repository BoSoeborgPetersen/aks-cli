WriteAndSetUsage "aks cert-manager uninstall"

CheckCurrentCluster

Write-Info "Uninstalling Cert-Manager"

ExecuteCommand "helm3 uninstall cert-manager --namespace cert-manager $debugString"