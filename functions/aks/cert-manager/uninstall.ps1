WriteAndSetUsage "aks cert-manager uninstall"

VerifyCurrentCluster

Write-Info "Uninstalling Cert-Manager"

ExecuteCommand "helm3 uninstall cert-manager --namespace cert-manager $debugString"