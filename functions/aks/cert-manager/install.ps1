param($version)

WriteAndSetUsage "aks cert-manager install [version]"

CheckCurrentCluster
$certManagerName = GetCertManagerDeploymentName

Helm3Command "repo add jetstack https://charts.jetstack.io"
Helm3Command "repo update"

$latestVersion = HelmLatestChartVersion "jetstack/cert-manager"
CheckVersion ([ref]$version) -default $latestVersion

Write-Info "Installing Cert-Manager"

KubectlCommand "create ns cert-manager"
KubectlCommand "apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v$version/cert-manager.crds.yaml"
Helm3Command "install $certManagerName jetstack/cert-manager -n cert-manager --version v$version"