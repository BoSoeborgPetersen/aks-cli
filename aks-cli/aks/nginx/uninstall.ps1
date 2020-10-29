param($prefix, [switch] $purge, [switch] $yes)

WriteAndSetUsage ([ordered]@{
    "[prefix]" = "Kubernetes deployment name prefix"
    "[-purge]" = "Flag to delete Kubernetes namespace"
    "[-yes]" = "Skip verification"
})

$namespace = "ingress"
CheckCurrentCluster
$deployment = NginxDeploymentName $prefix

Write-Info "Uninstalling Nginx"

if ($yes -or (AreYouSure))
{
    HelmCommand "uninstall $deployment" -n $namespace
    
    if ($purge)
    {
        Write-Info "Remove Nginx namespace"
        
        KubectlCommand "delete ns $namespace"
    }
}