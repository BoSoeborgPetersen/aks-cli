param($version)

WriteAndSetUsage "aks cert-manager check" ([ordered]@{
    "[version]" = "Helm Chart version"
})

CheckCurrentCluster
$deployment = CertManagerDeploymentName
$latestVersion = HelmLatestChartVersion "jetstack/cert-manager"
$version = CheckVersion $version -default $latestVersion

Write-Info "Checking Cert-Manager"

Write-Info "Checking namespace"
KubectlCheck namespace $deployment
Write-Info "Namespace exists"

Write-Info "Checking Custom Resource Definitions"
KubectlCheckYaml https://github.com/jetstack/cert-manager/releases/download/v$version/cert-manager.crds.yaml
Write-Info "Custom Resource Definitions exists"

Write-Info "Checking Helm Chart"
HelmCheck $deployment -n $deployment
Write-Info "Helm Chart exists"

Write-Info "Cert-Manager exists"