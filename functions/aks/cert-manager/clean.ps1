# TODO: Validate Version with Regex '^[\d]+\.[\d]+$'
param($version)

$usage = Write-Usage "aks cert-manager clean [version]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$version) "0.12"

Write-Info ("Clean Cert-Manager namespace, and Custom Resource Definitions from current AKS cluster '$($selectedCluster.Name)', which will remove all custom Kubernetes resources (certificaterequests, certificates, challenges, clusterissuers, healthstates, issuers, orders)")

ExecuteCommand ("kubectl delete ns cert-manager $kubeDebugString")
ExecuteCommand ("kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml $kubeDebugString")