# TODO: Maybe merge into uninstall as parameter.
param($version)

WriteAndSetUsage "aks cert-manager purge [version]"

CheckCurrentCluster
# TODO: Somehow get the newest version from helm.
SetDefaultIfEmpty ([ref]$version) "0.14"

CheckVersion $version

Write-Info "Purge Cert-Manager namespace, and Custom Resource Definitions, which will remove resources (certificaterequests, certificates, challenges, clusterissuers, healthstates, issuers, orders)"

if (AreYouSure)
{
    ExecuteCommand "kubectl delete ns cert-manager $kubeDebugString"
    ExecuteCommand "kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml $kubeDebugString"
}