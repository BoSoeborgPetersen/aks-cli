param($version, [switch] $preview = $false)

WriteAndSetUsage "aks upgrade [version] [-preview]"

CheckCurrentCluster

if ($version) 
{
    AzCheckUpgradableVersion ([ref]$version) $preview
    Write-Info "Upgrading current cluster to version '$version'"
}
else
{
    $previewString = ConditionalOperator (!$preview) "?!isPreview"
    # TODO: Fix version sorting (1.5.10 will come before 1.5.7) (use: SemanticVersionSort function).
    $version = AzAksCurrentQuery "get-upgrades" -q "'controlPlaneProfile.upgrades[$previewString].kubernetesVersion | sort(@) | [-1]'" -o tsv

    if ($version)
    {
        $previewString = ConditionalOperator $preview " (allow previews)"
        Write-Info "Upgrading current cluster to version '$version', which is the newest upgradable version $previewString"
    }
    else
    {
        Write-Info "Cluster has the newest available version"
        exit
    }
}
    
if (AreYouSure)
{
    AzAksCurrentCommand "upgrade" -version $version
}