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
    Helm3Command "uninstall cert-manager -n cert-manager"
    if ($purge)
    {
        KubectlCommand "delete ns cert-manager"
        KubectlCommand "delete -f https://github.com/jetstack/cert-manager/releases/download/v$version/cert-manager.crds.yaml"
    }
}