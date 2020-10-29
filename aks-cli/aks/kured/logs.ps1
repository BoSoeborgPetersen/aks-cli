param($index = -1)

WriteAndSetUsage ([ordered]@{
    "[index]" = "Index of the pod to show logs from"
})

CheckCurrentCluster
$deployment = KuredDeploymentName

if ($index -ne -1)
{
    Write-Info "Show Kured (KUbernetes REboot Daemon) logs from pod (index: $index)"
    
    $pod = KubectlGetPod $deployment $deployment $index
    KubectlCommand "logs $pod -n $deployment"
}
else
{
    Write-Info "Show Kured (KUbernetes REboot Daemon) logs with Stern"

    SternCommand $deployment -n $deployment
}