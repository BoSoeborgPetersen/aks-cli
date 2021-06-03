param([switch] $yes, [switch] $skipNamespace)

WriteAndSetUsage ([ordered]@{
    "[-yes]" = "Skip verification"
    "[-skipNamespace]" = "Skip Namespace deletion"
})

CheckCurrentCluster
$deployment = VpaDeploymentName

Write-Info "Uninstalling Vertical Pod Autoscaler"

if ($yes -or (AreYouSure))
{
    HelmCommand "uninstall $deployment" -n $deployment

    if (!$skipNamespace)
    {
        KubectlCommand "delete namespace $deployment"
    }
}