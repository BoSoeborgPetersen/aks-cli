# TODO: Add message reading something like "ACCESS DENIED !!!", when unauthorized.
param([switch] $cluster, $resourceGroup, [switch] $clean, [switch] $clear = $true)

WriteAndSetUsage ([ordered]@{
    "[-cluster]" = "Only switch AKS cluster, not Azure subscription"
    "[resource group]" = "Switch to this AKS cluster, instead of using menu"
    "[-clean]" = "Clear and replace AKS cluster credentials"
})

if ($clean)
{
    Write-Info "Clearing AKS cluster credentials"
    KubectlClearConfig $resourceGroup
}

if (!$resourceGroup)
{
    if (!$cluster)
    {
        SwitchCurrentSubscription
    }

    SwitchCurrentCluster -clear $clear
}
else
{
    Write-Info "Switching AKS cluster '$resourceGroup'"
    SwitchCurrentClusterTo $resourceGroup
}