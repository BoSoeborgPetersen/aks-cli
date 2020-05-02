param($deployment)

WriteAndSetUsage "aks nginx uninstall [deployment name]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeployment = GetNginxDeploymentName $deployment

Write-Info "Uninstall Nginx"

Helm3Command "uninstall $nginxDeployment -n $namespace"
