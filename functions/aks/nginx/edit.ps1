param($deployment)

WriteAndSetUsage "aks nginx edit [deployment name]"

CheckCurrentCluster
$nginxDeploymentName = GetNginxDeploymentName $deployment

Write-Info "Edit Nginx configmap"

KubectlCommand "edit configmap $nginxDeploymentName-controller -n ingress"