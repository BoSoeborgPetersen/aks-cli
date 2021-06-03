param($index = -1)

WriteAndSetUsage ([ordered]@{
    "[index]" = "Index of the pod to show logs from"
})

CheckCurrentCluster
$deployment = VpaDeploymentName

if ($index -ne -1)
{
    Write-Info "Show Vertical Pod Autoscaler logs from pod (index: $index)"
    
    $pod = KubectlGetPod $deployment $deployment $index
    KubectlCommand "logs $pod -n $deployment"
}
else
{
    Write-Info "Show Vertical Pod Autoscaler logs with Stern"

    SternCommand $deployment -n $deployment
}