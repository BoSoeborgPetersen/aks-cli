param([switch] $yes, [switch] $skipNamespace)

WriteAndSetUsage ([ordered]@{
    "[-yes]" = "Skip verification"
    "[-skipNamespace]" = "Skip Namespace deletion"
})

CheckCurrentCluster
$deployment = KedaDeploymentName

Write-Info "Uninstalling Keda (Kubernetes Event-driven Autoscaling)"

if ($yes -or (AreYouSure))
{
    HelmCommand "uninstall $deployment" -n $deployment

    if (!$skipNamespace)
    {
        KubectlCommand "delete namespace $deployment"
    }
}