param($deployment, $index)

$usage = Write-Usage "aks nginx config [deployment] [index]"

VerifyCurrentCluster $usage
$nginxDeployment = GetNginxDeploymentName $deployment
SetDefaultIfEmpty ([ref]$index) "1"

VerifyDeployment $deployment

Write-Info "Print config file for Nginx-Ingress"

$pod = KubectlGetPod $usage $nginxDeployment "ingress" $index
ExecuteCommand "kubectl exec -n ingress $pod -- cat /etc/nginx/nginx.conf $kubeDebugString"