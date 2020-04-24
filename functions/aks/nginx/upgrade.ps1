param($deployment)

WriteAndSetUsage "aks nginx upgrade [deployment name]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeployment = GetNginxDeployment $deployment
KubectlCheckDeployment $deployment -namespace $namespace

Write-Info "Upgrade Nginx"

ExecuteCommand "helm3 upgrade $nginxDeployment stable/nginx-ingress -n $namespace --reuse-values $debugString"