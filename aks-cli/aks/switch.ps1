param([switch] $cluster, $resourceGroup, [switch] $clean)

WriteAndSetUsage ([ordered]@{
    "[-cluster]" = "Only switch AKS cluster, not Azure subscription"
    "[resource group]" = "Switch to this AKS cluster, instead of using menu"
    "[-clean]" = "Clear and replace AKS cluster credentials"
})

if (!$cluster)
{
    SwitchCurrentSubscription -clear
}

if (!$resourceGroup)
{
    SwitchCurrentCluster -clear
}
else
{
    if ($clean)
    {
        Write-Info "Clearing AKS cluster credentials"
        KubectlClearConfig $resourceGroup
    }
    
    Write-Info "Switching AKS cluster"
    SwitchCurrentClusterTo $resourceGroup
}