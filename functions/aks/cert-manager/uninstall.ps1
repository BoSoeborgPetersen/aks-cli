param($version, [switch] $purge)

WriteAndSetUsage "aks cert-manager uninstall [version] [-purge]"

CheckCurrentCluster
$latestVersion = HelmLatestChartVersion "jetstack/cert-manager"
CheckVersion ([ref]$version) -default $latestVersion

Write-Info "Uninstalling Cert-Manager"
if ($purge)
{
    Write-Info "Purging Cert-Manager namespace, and Custom Resource Definitions, which will remove resources (certificaterequests, certificates, challenges, clusterissuers, healthstates, issuers, orders)"
}

if (AreYouSure)
{
    Helm3Command "uninstall cert-manager --namespace cert-manager"
    if ($purge)
    {
        KubectlCommand "delete ns cert-manager"
        KubectlCommand "delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml"
    }
}