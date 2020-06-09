param($prefix, $configPrefix)

WriteAndSetUsage "aks nginx upgrade" ([ordered]@{
    "[prefix]" = "Kubernetes deployment name prefix"
})

$namespace = "ingress"
CheckCurrentCluster
$deployment = NginxDeploymentName $prefix
$configFile = PrependWithDash $configPrefix "nginx-config.yaml"
KubectlCheckDaemonSet $deployment -namespace $namespace
$resourceGroup = CurrentClusterResourceGroup
$dns = PrependWithDash $prefix "$resourceGroup"

Write-Info "Upgrade Nginx"

if (AreYouSure)
{
    HelmCommand "upgrade $deployment stable/nginx-ingress --atomic --reuse-values --set defaultBackend.autoscaling.minReplicas=1 --set controller.service.internal.enabled=false --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dns -f $PSScriptRoot/config/$configFile" -n $namespace
}