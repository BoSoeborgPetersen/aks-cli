# MaybeDo: Use this default resource group in all aks functions that require a resource group.
param($resourceGroup)

WriteAndSetUsage "aks state resource-group" ([ordered]@{
    "[resource group]" = "Default resource group"
})

if ($resourceGroup)
{
    Write-Info "Setting global state to use default resource group '$resourceGroup'"
}
else 
{
    Write-Info "Setting global state to not use a default resource group"
}

SetDefaultResourceGroup $resourceGroup