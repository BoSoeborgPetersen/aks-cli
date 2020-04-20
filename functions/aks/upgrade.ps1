param($version, [switch] $preview = $false)

$usage = Write-Usage "aks upgrade [version] [-preview]"

VerifyCurrentCluster $usage

if ($version) 
{
    CheckVersionExists $version $preview
    Write-Info "Upgrading current cluster to version '$version'"
}
else
{
    $previewString = ConditionalOperator (!$preview) "?!isPreview"
    # TODO: Fix version sorting (1.5.10 will come before 1.5.7).
    $version = ExecuteQuery "az aks get-upgrades -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query 'controlPlaneProfile.upgrades[$previewString].kubernetesVersion | sort(@) | [-1]' -o tsv $debugString"

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
    ExecuteCommand "az aks upgrade -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) -k $version $debugString"
}