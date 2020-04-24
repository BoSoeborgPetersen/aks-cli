param($deployment, $index)

WriteAndSetUsage "aks nginx config [deployment] [index]"

VerifyCurrentCluster
$nginxDeployment = GetNginxDeploymentName $deployment
SetDefaultIfEmpty ([ref]$index) "1"

KubectlVerifyDeployment $deployment

Write-Info "Print config file for Nginx-Ingress"

$pod = KubectlGetPod $nginxDeployment "ingress" $index
ExecuteCommand "kubectl exec -n ingress $pod -- cat /etc/nginx/nginx.conf $kubeDebugString"