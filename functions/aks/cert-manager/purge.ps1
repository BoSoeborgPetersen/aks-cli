# TODO: Maybe merge into uninstall as parameter.
param($version)

$usage = Write-Usage "aks cert-manager purge [version]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$version) "0.14"

VerifyVersion $version

Write-Info "Purge Cert-Manager namespace, and Custom Resource Definitions, which will remove resources (certificaterequests, certificates, challenges, clusterissuers, healthstates, issuers, orders)"

if (AreYouSure)
{
    ExecuteCommand "kubectl delete ns cert-manager $kubeDebugString"
    ExecuteCommand "kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml $kubeDebugString"
}