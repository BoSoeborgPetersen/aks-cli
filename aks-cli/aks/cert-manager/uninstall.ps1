param($version, [switch] $purge, [switch] $yes)

WriteAndSetUsage ([ordered]@{
    "[version]" = "Helm Chart version"
    "[-purge]" = "Also remove Kubernetes namespace and Cert-Manager Custom Resource Definitions (CRDs)"
    "[-yes]" = "Skip verification"
})

CheckCurrentCluster
$deployment = CertManagerDeploymentName
$latestVersion = HelmLatestChartVersion "jetstack/cert-manager"
$version = CheckVersion $version -default $latestVersion

Write-Info "Uninstalling Cert-Manager"
if ($purge)
{
    Write-Info "Purging Cert-Manager namespace, and Custom Resource Definitions, which will remove resources (certificaterequests, certificates, challenges, clusterissuers, healthstates, issuers, orders)"
}

if ($yes -or (AreYouSure))
{
    HelmCommand "uninstall $deployment" -n cert-manager
    
    if ($purge)
    {
        KubectlCommand "delete ns $deployment"
        KubectlCommand "delete -f https://github.com/jetstack/cert-manager/releases/download/v$version/cert-manager.crds.yaml"
    }
}