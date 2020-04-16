$usage = Write-Usage "aks cert-manager uninstall"

VerifyCurrentCluster $usage

Write-Info ("Uninstalling Cert-Manager from current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "helm3 uninstall cert-manager --namespace cert-manager $debugString"