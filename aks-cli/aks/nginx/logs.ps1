param($index = -1, $prefix)

WriteAndSetUsage ([ordered]@{
    "[index]" = "Index of the pod to show logs from"
    "[prefix]" = "Kubernetes deployment name prefix"
})

$namespace = "ingress"
CheckCurrentCluster
$deployment =NginxDeploymentName $prefix
KubectlCheckDaemonSet $deployment -namespace $namespace

if ($index -ne -1)
{
    Write-Info "Show Nginx logs from pod (index: $index) in deployment '$deployment'"

    $pod = KubectlGetPod $deployment $namespace $index
    KubectlCommand "logs -n $namespace $pod"
}
else
{
    Write-Info "Show Nginx logs with Stern"
    
    SternCommand -l $deployment -n $namespace
}