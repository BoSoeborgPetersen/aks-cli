WriteAndSetUsage "aks cert-manager upgrade"

CheckCurrentCluster
$deployment = CertManagerDeploymentName
$version = HelmLatestChartVersion "jetstack/cert-manager"

Write-Info "Upgrading Certificate Manager"

KubectlCommand "apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v$version/cert-manager.crds.yaml"
HelmCommand "upgrade $deployment jetstack/cert-manager --reuse-values -f $PSScriptRoot/config/cert-manager-config.yaml" -n $deployment