param($deploymentName)

$usage = Write-Usage "aks nginx upgrade [deployment name]"

VerifyCurrentCluster $usage

VerifyDeployment $deploymentName $namespace

$nginxDeploymentName = GetNginxDeploymentName $deploymentName

Write-Info "Upgrade Nginx-Ingress"

ExecuteCommand "helm upgrade --reuse-values $nginxDeploymentName stable/nginx-ingress $debugString"