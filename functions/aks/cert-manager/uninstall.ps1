$usage = Write-Usage "aks cert-manager uninstall"

VerifyCurrentCluster $usage

Write-Info "Uninstalling Cert-Manager"

ExecuteCommand "helm3 uninstall cert-manager --namespace cert-manager $debugString"