# TODO: Validate Version with Regex '^[\d]+\.[\d]+$'
# TODO: Add "Are You Sure" question
param($version)

$usage = Write-Usage "aks cert-manager purge [version]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$version) "0.14"

Write-Info ("Clean Cert-Manager namespace, and Custom Resource Definitions from current AKS cluster '$($selectedCluster.Name)', which will remove all custom Kubernetes resources (certificaterequests, certificates, challenges, clusterissuers, healthstates, issuers, orders)")

ExecuteCommand ("kubectl delete ns cert-manager $kubeDebugString")
ExecuteCommand ("kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml $kubeDebugString")