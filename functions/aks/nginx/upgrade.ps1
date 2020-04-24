param($deploymentName)

WriteAndSetUsage "aks nginx upgrade [deployment name]"

VerifyCurrentCluster

KubectlVerifyDeployment $deploymentName $namespace

$nginxDeploymentName = GetNginxDeploymentName $deploymentName

Write-Info "Upgrade Nginx-Ingress"

ExecuteCommand "helm upgrade --reuse-values $nginxDeploymentName stable/nginx-ingress $debugString"