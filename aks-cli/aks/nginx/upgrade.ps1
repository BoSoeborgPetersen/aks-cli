param($deployment)

WriteAndSetUsage "aks nginx upgrade [deployment name]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeployment = GetNginxDeploymentName $deployment
KubectlCheckDaemonSet ([ref]$nginxDeployment) -namespace $namespace

Write-Info "Upgrade Nginx"

if (AreYouSure)
{
    Helm3Command "upgrade $nginxDeployment stable/nginx-ingress -n $namespace --atomic --reuse-values"
}