# TODO: Validate Version with Regex '^[\d]+\.[\d]+$'
param($version)

$usage = Write-Usage "aks cert-manager install [version]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$version) "0.12"

$certManagerName = GetCertManagerDeploymentName

Write-Info ("Installing Cert-Manager on current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-$versopm/deploy/manifests/00-crds.yaml $kubeDebugString")
ExecuteCommand ("kubectl create ns cert-manager $kubeDebugString")
ExecuteCommand ("helm repo add jetstack https://charts.jetstack.io $debugString")
ExecuteCommand ("helm repo update $debugString")
ExecuteCommand ("helm install -n $certManagerName --namespace cert-manager --version v$versopm.0 jetstack/cert-manager $debugString")