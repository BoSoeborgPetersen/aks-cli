# TODO: Only remove namespace with PURGE parameter.
param($deploymentName)

$usage = Write-Usage "aks nginx uninstall [deployment name]"

VerifyCurrentCluster $usage
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

Write-Info ("Uninstall Nginx-Ingress")

ExecuteCommand "helm3 uninstall $nginxDeploymentName -n ingress $debugString"
#ExecuteCommand "kubectl delete namespace ingress $kubeDebugString"
