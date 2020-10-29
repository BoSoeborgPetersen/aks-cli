param($version, [switch] $skipNamespace)

WriteAndSetUsage ([ordered]@{
    "[version]" = "Helm Chart version"
    "[-skipNamespace]" = "Skip Namespace creation"
})

CheckCurrentCluster
$deployment = CertManagerDeploymentName

$latestVersion = HelmLatestChartVersion "jetstack/cert-manager"
$version = CheckVersion $version -default $latestVersion

Write-Info "Installing Cert-Manager"

if (!$skipNamespace)
{
    KubectlCommand "create ns $deployment"
}
KubectlCommand "apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v$version/cert-manager.crds.yaml"
HelmCommand "install $deployment jetstack/cert-manager --version v$version -f $PSScriptRoot/config/cert-manager-config.yaml" -n $deployment