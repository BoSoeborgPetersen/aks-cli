param($deploymentName)

$usage = Write-Usage "aks nginx uninstall [deployment name]"

VerifyCurrentCluster $usage

VerifyDeployment $deploymentName $namespace

$nginxDeploymentName = GetNginxDeploymentName $deploymentName

Write-Info "Uninstall Nginx-Ingress"

ExecuteCommand "helm3 uninstall $nginxDeploymentName -n ingress $debugString"
