param($index = 0, $prefix)

WriteAndSetUsage "aks nginx print" ([ordered]@{
    "[index]" = "Index of the pod to show logs from"
    "[prefix]" = "Kubernetes deployment name prefix"
})

$namespace = "ingress"
CheckCurrentCluster
$deployment = NginxDeploymentName $prefix
KubectlCheckDaemonSet $deployment -namespace $namespace

Write-Info "Print Nginx config file from inside the container"

$pod = KubectlGetPod $deployment $namespace $index
KubectlCommand "exec -n $namespace $pod -- cat /etc/nginx/nginx.conf"