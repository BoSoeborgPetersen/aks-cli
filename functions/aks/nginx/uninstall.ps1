param($deployment)

WriteAndSetUsage "aks nginx uninstall [deployment name]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeployment = GetNginxDeployment $deployment
KubectlCheckDeployment $deployment -namespace $namespace

Write-Info "Uninstall Nginx"

ExecuteCommand "helm3 uninstall $nginxDeployment -n $namespace $debugString"
