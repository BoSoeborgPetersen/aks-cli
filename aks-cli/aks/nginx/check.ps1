param($prefix)

WriteAndSetUsage "aks nginx check" ([ordered]@{
    "[prefix]" = "Kubernetes deployment name prefix"
})

$namespace = "ingress"
CheckCurrentCluster
$deployment = NginxDeploymentName $prefix

Write-Info "Checking Nginx"

# LaterDo: Check Public IP.

Write-Info "Checking namespace"
KubectlCheck namespace $namespace
Write-Info "Namespace exists"

Write-Info "Checking Nginx Chart"
HelmCheck $deployment -n $namespace
Write-Info "Nginx Chart exists"

Write-Info "Nginx exists"