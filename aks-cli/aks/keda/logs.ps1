param($index = -1)

WriteAndSetUsage ([ordered]@{
    "[index]" = "Index of the pod to show logs from"
})

CheckCurrentCluster
$deployment = KedaDeploymentName

if ($index -ne -1)
{
    Write-Info "Show Keda (Kubernetes Event-driven Autoscaling) logs from pod (index: $index)"
    
    $pod = KubectlGetPod $deployment $deployment $index
    KubectlCommand "logs $pod -n $deployment"
}
else
{
    Write-Info "Show Keda (Kubernetes Event-driven Autoscaling) logs with Stern"

    SternCommand $deployment -n $deployment
}