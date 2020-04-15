# TODO: Validate Version with Regex '^[\d]+\.[\d]+$'
# TODO: Only remove CRD's with PURGE parameter.
param($version)

$usage = Write-Usage "aks cert-manager uninstall [version]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$version) "0.14"

Write-Info ("Uninstalling Cert-Manager from current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "helm3 uninstall cert-manager --namespace cert-manager $debugString"
#ExecuteCommand ("kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml $kubeDebugString")