param([switch] $yes, [switch] $skipNamespace)

WriteAndSetUsage "aks kured uninstall" ([ordered]@{
    "[-yes]" = "Skip verification"
    "[-skipNamespace]" = "Skip Namespace deletion"
})

CheckCurrentCluster
$deployment = KuredDeploymentName

Write-Info "Uninstalling Kured (KUbernetes REboot Daemon)"

if ($yes -or (AreYouSure))
{
    HelmCommand "uninstall $deployment" -n $deployment

    if (!$skipNamespace)
    {
        KubectlCommand "delete namespace $deployment"
    }
}