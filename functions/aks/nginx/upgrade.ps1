param($deployment)

WriteAndSetUsage "aks nginx upgrade [deployment name]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeployment = GetNginxDeployment $deployment
KubectlCheckDeployment ([ref]$deployment) -namespace $namespace

Write-Info "Upgrade Nginx"

Helm3Command "upgrade $nginxDeployment stable/nginx-ingress -n $namespace --reuse-values"