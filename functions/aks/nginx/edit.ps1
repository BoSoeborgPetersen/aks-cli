param($deployment)

WriteAndSetUsage "aks nginx edit [deployment name]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeploymentName = GetNginxDeploymentName $deployment
KubectlCheckDeployment $deployment -namespace $namespace

Write-Info "Edit Nginx configmap"

ExecuteCommand "aks edit configmap $nginxDeploymentName-controller -n $namespace"