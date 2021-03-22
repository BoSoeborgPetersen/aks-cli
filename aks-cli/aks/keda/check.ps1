WriteAndSetUsage

CheckCurrentCluster
$deployment = KedaDeploymentName

Write-Info "Checking Keda (Kubernetes Event-driven Autoscaling)"

Write-Info "Checking namespace"
KubectlCheck namespace $deployment
Write-Info "Namespace exists"

Write-Info "Checking Helm Chart"
HelmCheck $deployment -n $deployment
Write-Info "Helm Chart exists"

Write-Info "Keda (Kubernetes Event-driven Autoscaling) exists"