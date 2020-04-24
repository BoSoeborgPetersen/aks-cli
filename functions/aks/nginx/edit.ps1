param($deploymentName)

WriteAndSetUsage "aks nginx edit [deployment name]"

VerifyCurrentCluster
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

KubectlVerifyDeployment $deploymentName

Write-Info "Edit configmap for Nginx-Ingress"

ExecuteCommand "aks edit configmap $nginxDeploymentName-controller -n ingress"