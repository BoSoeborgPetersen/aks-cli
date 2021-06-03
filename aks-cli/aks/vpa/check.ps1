WriteAndSetUsage

CheckCurrentCluster
$deployment = VpaDeploymentName

Write-Info "Checking Vertical Pod Autoscaler"

Write-Info "Checking namespace"
KubectlCheck namespace $deployment
Write-Info "Namespace exists"

Write-Info "Checking Helm Chart"
HelmCheck $deployment -n $deployment
Write-Info "Helm Chart exists"

Write-Info "Vertical Pod Autoscaler exists"