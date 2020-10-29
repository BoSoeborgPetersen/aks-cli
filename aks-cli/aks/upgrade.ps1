param($version, [switch] $preview)

WriteAndSetUsage ([ordered]@{
    "[version]" = "Version to upgrade to (default: newest stable upgradable version)"
    "[-preview]" = "Allow upgrade to preview version"
})

CheckCurrentCluster

if ($version) 
{
    AzCheckUpgradableVersion $version $preview
    Write-Info "Upgrading current cluster to version '$version'"
}
else
{
    $previewString = ConditionalOperator (!$preview) "?!isPreview"
    $version = AzAksCurrentQuery "get-upgrades" -q "controlPlaneProfile.upgrades[$previewString].kubernetesVersion | sort(@) | [-1]" -o tsv

    if ($version)
    {
        $previewString = ConditionalOperator $preview "(allow previews)"
        Write-Info "Upgrading current cluster to version '$version', which is the newest upgradable version $previewString"
    }
    else
    {
        Write-Info "Cluster has the newest available version" -exit
    }
}
    
if (AreYouSure)
{
    AzAksCurrentCommand "upgrade -y" -version $version
}