function AzCommand($command, $query, $output)
{
    $queryString = ConditionalOperator $query "--query $query"
    $outputString = ConditionalOperator $output "-o $output"

    ExecuteCommand "az $command $queryString $outputString $debugString"
}

function AzAksCommand($command, $location, $version, $query, $output)
{
    $locationString = ConditionalOperator $location "-l $location"
    $versionString = ConditionalOperator $version "-k $version"

    AzCommand "aks $command $locationString $versionString" -q $query -o $output
}

function AzAksCurrentCommand($command, $location, $version, $query, $output)
{
    $resourceGroup = GetCurrentClusterResourceGroup
    $cluster = GetCurrentClusterName

    AzAksCommand "$command -g $resourceGroup -n $cluster" -l $location -version $version -q $query -o $output
}

function AzQuery($command, $query, $subscription, $output)
{
    $queryString = ConditionalOperator $query "--query $query"
    $subscriptionString = ConditionalOperator $subscription "--subcription $subscription"
    $outputString = ConditionalOperator $output "-o $output"

    return ExecuteQuery "az $command $queryString $subscriptionString $outputString $debugString"
}

function AzAksQuery($command, $location, $version, $query, $output)
{
    $locationString = ConditionalOperator $location "-l $location"
    $versionString = ConditionalOperator $version "-k $version"

    return AzQuery "aks $command $locationString $versionString" -q $query -o $output
}

function AzAksCurrentQuery($command, $location, $version, $query, $output)
{
    $resourceGroup = GetCurrentClusterResourceGroup
    $cluster = GetCurrentClusterName

    return AzAksQuery "$command -g $resourceGroup -n $cluster" -l $location -version $version -q $query -o $output
}

function AzCheckSubscription($name)
{
    $check = AzQuery "account list" -q "`"[?name=='$name'].name`"" -o tsv
    Check $check "Subscription '$name' does not exist"
}

function AzCheckLocation($name)
{
    $check = AzQuery "account list-locations" -q "`"[?name=='$name'].name`"" -o tsv
    Check $check "Location '$name' does not exist"
}

function AzCheckUpgradableVersion([ref][string] $version, $preview)
{
    CheckVersion $version

    $previewString = ConditionalOperator $preview "" "!isPreview &&"
    $check = AzAksCurrentQuery "get-upgrades" -q "`"controlPlaneProfile.upgrades[?$previewString kubernetesVersion=='$($version.Value)'].kubernetesVersion`"" -o tsv
    Check $check "Version '$($version.Value)' does not exist"
}

function AzCheckResourceGroup($name, $subscription)
{
    $subscription = ConditionalOperator $subscription "--subscription $subscription"
    $check = AzQuery "group list" -q "`"[?name=='$name'].name`"" $subscription -o tsv
    Check $check "Resource Group '$name' does not exist"
}

function AzCheckNotResourceGroup($name)
{
    $check = AzQuery "group list" -q "`"[?name=='$name'].name`"" -o tsv
    Check (!$check) "Resource Group '$name' already exist"
}

function AzCheckServicePrincipal($keyVault, $name)
{
    $check = AzQuery "keyvault secret list --vault-name $keyVault" -q "`"[?id=='https://$keyVault.vault.azure.net/secrets/$name']`"" -o tsv
    Check $check "Service Principal '$name' does not exist"
}

function AzCheckVirtualMachineSize([ref] $name, $default)
{
    SetDefaultIfEmpty $name $default
    $check = (!$name.Value) -or (AzQuery "vm list-sizes -l northeurope" -q "`"[?name=='$($name.Value)'].name`"" -o tsv)
    Check $check "Virtual Machine Size '$($name.Value)' does not exist"
}

function AzCheckLoadBalancerSku([ref] $sku, $default)
{
    SetDefaultIfEmpty $sku $default
    $check = ($sku.Value -eq "basic") -or ($sku.Value -eq "standard")
    Check $check "Load Balancer SKU '$($sku.Value)' does not exist"
}

function AzCheckContainerRegistry($name, $subscription)
{
    $check = AzQuery "acr list" -q "`"[?name=='$name'].name`"" -s "'$subscription'" -o tsv
    Check $check "Azure Container Registry '$name' in subscription '$subscription' does not exist"
}

function AzCheckNotContainerRegistry($name, $subscription)
{
    $check = AzQuery "acr list" -q "`"[?name=='$name'].name`"" -s "'$subscription'" -o tsv
    Check (!$check) "Azure Container Registry '$name' in subscription '$subscription' does not exist"
}

function AzCheckKeyVault($name, $subscription)
{
    $check = AzQuery "keyvault list" -q "`"[?name=='$name'].name`"" -s "'$subscription'" -o tsv
    Check $check "Azure Key Vault '$name' in subscription '$subscription' does not exist"
}

function AzCheckNotKeyVault($name, $subscription)
{
    $check = AzQuery "keyvault list" -q "`"[?name=='$name'].name`"" -s "'$subscription'" -o tsv
    Check (!$check) "Azure Key Vault '$name' in subscription '$subscription' does not exist"
}