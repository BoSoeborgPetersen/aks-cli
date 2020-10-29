WriteAndSetUsage

CheckCurrentCluster
$deployment = KuredDeploymentName

Write-Info "Checking Kured (KUbernetes REboot Daemon)"

Write-Info "Checking namespace"
KubectlCheck namespace $deployment
Write-Info "Namespace exists"

Write-Info "Checking Helm Chart"
HelmCheck $deployment -n $deployment
Write-Info "Helm Chart exists"

Write-Info "Kured (KUbernetes REboot Daemon) exists"