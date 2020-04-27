function CheckSubscriptionExists($subscription)
{
    $check = ExecuteQuery "az account list --query `"[?name=='$subscription'].name`" -o tsv"
    Check $check "Subscription '$subscription' does not exist"
}

function CheckLocationExists($location)
{
    $check = ExecuteQuery "az account list-locations --query `"[?name=='$location'].name`" -o tsv"
    Check $check "Location '$location' does not exist"
}

function CheckVersionExists($version, $preview)
{
    CheckVersion $version

    $previewString = ConditionalOperator (!$preview) "!isPreview &&"
    $versionCheck = ExecuteQuery "az aks get-upgrades -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query `"controlPlaneProfile.upgrades[?$previewString kubernetesVersion=='$version'].kubernetesVersion`" -o tsv"
    Check $versionCheck "Version '$version' does not exist"
}

function CheckResourceGroupExists($resourceGroup, $subscription)
{
    $subscription = ConditionalOperator $subscription "--subscription $subscription"
    # TODO: Test and maybe replace.
    # $check = ExecuteQuery "az group show -g $resourceGroup --query name -o tsv"
    $check = ExecuteQuery "az group list --query `"[?name=='$resourceGroup'].name`" $subscription -o tsv"
    Check $check "Resource Group '$resourceGroup' does not exist"
}

function CheckResourceGroupNotExists($resourceGroup)
{
    # TODO: Test and maybe replace.
    # $check = ExecuteQuery "az group show -g $resourceGroup --query name -o tsv"
    $check = ExecuteQuery "az group list --query `"[?name=='$resourceGroup'].name`" -o tsv"
    Check (!$check) "Resource Group '$resourceGroup' already exist"
}

function CheckServicePrincipalExists($keyVault, $name)
{
    $check = ExecuteQuery "az keyvault secret list --vault-name $keyVault --query `"[?id=='https://$keyVault.vault.azure.net/secrets/$name']`" -o tsv"
    Check $check "Service Principal '$name' does not exist"
}

function CheckVirtualMachineSizeExists([ref] $size, $default)
{
    if ($default)
    {
        SetDefaultIfEmpty $size $default
    }
    $check = (!$size.Value) -or (ExecuteQuery "az vm list-sizes -l northeurope --query `"[?name=='$($size.Value)'].name`" -o tsv")
    Check $check "Virtual Machine Size '$($size.Value)' does not exist"
}

function CheckLoadBalancerSkuExists([ref] $sku, $default)
{
    if ($default)
    {
        SetDefaultIfEmpty $sku $default
    }
    $check = ($sku.Value -eq "basic") -or ($sku.Value -eq "standard")
    Check $check "Load Balancer SKU '$sku.Value' does not exist"
}

function CheckContainerRegistryExists($registry, $subscription)
{
    $check = ExecuteQuery "az acr show -n $registry, $subscription --subscription '$subscription' -o tsv"
    Check $check "Azure Container Registry '$registry' in subscription '$subscription' does not exist"
}

function CheckKeyVaultExists($keyVault, $subscription)
{
    $check = ExecuteQuery "az keyvault show -n $keyVault --subscription '$subscription' -o tsv"
    Check $check "Azure Key Vault '$keyVault' in subscription '$subscription' does not exist"
}