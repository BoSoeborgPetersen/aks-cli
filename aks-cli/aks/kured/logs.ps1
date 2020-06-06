param($index)

WriteAndSetUsage "aks kured logs [index]"

CheckCurrentCluster

if($index)
{
    Write-Info "Show Kured (KUbernetes REboot Daemon) logs from pod (index: $index)"
    
    $pod = KubectlGetPod "kured" "kured" $index
    KubectlCommand "logs $pod -n kured"
}
else
{
    Write-Info "Show Kured (KUbernetes REboot Daemon) logs with Stern"

    ExecuteCommand "stern kured -n kured"
}