# TODO: Validate Version with Regex '^[\d]+\.[\d]+$'
param($version)

$usage = Write-Usage "aks cert-manager uninstall [version]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$version) "0.12"

Write-Info ("Uninstalling Cert-Manager from current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "helm delete cert-manager --purge $debugString"
ExecuteCommand ("kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml $kubeDebugString")