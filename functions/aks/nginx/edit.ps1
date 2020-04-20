param($deploymentName)

$usage = Write-Usage "aks nginx edit [deployment name]"

VerifyCurrentCluster $usage
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

VerifyDeployment $deploymentName

Write-Info "Edit configmap for Nginx-Ingress"

ExecuteCommand "aks edit configmap $nginxDeploymentName-controller -n ingress"