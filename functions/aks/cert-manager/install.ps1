param($version)

WriteAndSetUsage "aks cert-manager install [version]"

VerifyCurrentCluster
SetDefaultIfEmpty ([ref]$version) "0.14"
$certManagerName = GetCertManagerDeploymentName

VerifyVersion $version

Write-Info "Installing Cert-Manager"

ExecuteCommand "kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$version/deploy/manifests/00-crds.yaml $kubeDebugString"
ExecuteCommand "kubectl create ns cert-manager $kubeDebugString"
ExecuteCommand "helm3 repo add jetstack https://charts.jetstack.io $debugString"
ExecuteCommand "helm3 repo update $debugString"
ExecuteCommand "helm3 install $certManagerName jetstack/cert-manager --namespace cert-manager --version v$version.0 $debugString"