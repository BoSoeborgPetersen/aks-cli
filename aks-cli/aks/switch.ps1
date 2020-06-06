param($command, [switch] $cluster, $resourceGroup, [switch] $clean)

WriteAndSetUsage "aks switch [-cluster] [resource group] [-clean]"

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