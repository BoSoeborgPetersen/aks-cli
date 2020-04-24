param($deploymentName)

WriteAndSetUsage "aks nginx uninstall [deployment name]"

VerifyCurrentCluster

KubectlVerifyDeployment $deploymentName $namespace

$nginxDeploymentName = GetNginxDeploymentName $deploymentName

Write-Info "Uninstall Nginx-Ingress"

ExecuteCommand "helm3 uninstall $nginxDeploymentName -n ingress $debugString"
