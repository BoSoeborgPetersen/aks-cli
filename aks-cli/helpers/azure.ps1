function AzCommand($command, $query, $output)
{
    $queryString = ConditionalOperator $query " --query `"$query`""
    $outputString = ConditionalOperator $output " -o $output"

    ExecuteCommand ("az $command" + $queryString + $outputString + $debugString)
}

function AzAksCommand($command, $location, $version, $query, $output)
{
    $locationString = ConditionalOperator $location " -l $location"
    $versionString = ConditionalOperator $version " -k $version"

    AzCommand ("aks $command" + $locationString + $versionString) -q $query -o $output
}

function AzAksCurrentCommand($command, $location, $version, $query, $output)
{
    $resourceGroup = CurrentClusterResourceGroup
    $cluster = CurrentClusterName

    AzAksCommand "$command -g $resourceGroup -n $cluster" -l $location -version $version -q $query -o $output
}

function AzQuery($command, $query, $subscription, $output)
{
    $queryString = ConditionalOperator $query " --query `"$query`""
    $subscriptionString = ConditionalOperator $subscription " --subscription '$subscription'"
    $outputString = ConditionalOperator $output " -o $output"

    return ExecuteQuery ("az $command" + $queryString + $subscriptionString + $outputString + $debugString)
}

function AzAksQuery($command, $location, $version, $query, $output)
{
    $locationString = ConditionalOperator $location " -l $location"
    $versionString = ConditionalOperator $version " -k $version"

    return AzQuery ("aks $command" + $locationString + $versionString) -q $query -o $output
}

function AzAksCurrentQuery($command, $location, $version, $query, $output)
{
    $resourceGroup = CurrentClusterResourceGroup
    $cluster = CurrentClusterName

    return AzAksQuery "$command -g $resourceGroup -n $cluster" -l $location -version $version -q $query -o $output
}

function AzCheckSubscription($name)
{
    $check = AzQuery "account list" -q "[?name=='$name'].name" -o tsv
    Check $check "Subscription '$name' does not exist"
}

function AzCheckLocation($name)
{
    $check = AzQuery "account list-locations" -q "[?name=='$name'].name" -o tsv
    Check $check "Location '$name' does not exist"
}

function AzCheckUpgradableVersion($version, $preview)
{
    $version = CheckVersion $version

    $previewString = ConditionalOperator $preview "" "!isPreview &&"
    $check = AzAksCurrentQuery "get-upgrades" -q "controlPlaneProfile.upgrades[?$previewString kubernetesVersion=='$version'].kubernetesVersion" -o tsv
    Check $check "Version '$version', is not an upgradable version"
}

function AzCheckResourceGroup($name, $subscription, $location)
{
    $query = ConditionalOperator $location "name=='$name'&&location=='$location'" "name=='$name'"
    $check = AzQuery "group list" -q "[?$query].name" -s $subscription -o tsv
    Check $check "Resource Group '$name' does not exist"
}

function AzCheckNotResourceGroup($name)
{
    $check = AzQuery "group list" -q "[?name=='$name'].name" -o tsv
    Check (!$check) "Resource Group '$name' already exist"
}

function AzCheckServicePrincipal($name)
{
    $check = AzQuery "ad sp list --display-name $name" -q "[].displayName" -o tsv
    Check $check "Service Principal '$name' does not exist"
}

function AzCheckVirtualMachineSize($name)
{
    $check = (!$name) -or (AzQuery "vm list-sizes -l northeurope" -q "[?name=='$name'].name" -o tsv)
    Check $check "Virtual Machine Size '$name' does not exist"
}

function AzCheckLoadBalancerSku($sku)
{
    $check = ($sku -eq "basic") -or ($sku -eq "standard")
    Check $check "Load Balancer SKU '$sku' does not exist"
}

function AzCheckContainerRegistry($name, $subscription)
{
    $check = AzQuery "acr list" -q "[?name=='$name'].name" -s $subscription -o tsv
    Check $check "Azure Container Registry '$name' in subscription '$subscription' does not exist"
}

function AzCheckNotContainerRegistry($name, $subscription)
{
    $check = AzQuery "acr list" -q "[?name=='$name'].name" -s $subscription -o tsv
    Check (!$check) "Azure Container Registry '$name' in subscription '$subscription' does not exist"
}

function AzCheckKeyVault($name, $subscription)
{
    $check = AzQuery "keyvault list" -q "[?name=='$name'].name" -s $subscription -o tsv
    Check $check "Azure Key Vault '$name' in subscription '$subscription' does not exist"
}

function AzCheckNotKeyVault($name, $subscription)
{
    $check = AzQuery "keyvault list" -q "[?name=='$name'].name" -s $subscription -o tsv
    Check (!$check) "Azure Key Vault '$name' in subscription '$subscription' does not exist"
}

function AzCheckNodeAutoscaler
{
    $check = AzAksCurrentQuery "show" -q "agentPoolProfiles[?enableAutoScaling]" -o tsv
    Check $check "Node autoscaler does not exist"
}

function AzCheckRoleAssignment($id, $subscriptionId, $resourceGroup)
{
    $check = AzQuery "role assignment list --assignee $id --role contributor --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroup" -o tsv
    Check $check "Identity role assignment does not exist"
}

function AzCheckInsights($resourceGroup, $name)
{
    $check = AzQuery "monitor log-analytics workspace list -g $resourceGroup" -q "[?name=='$name'].name" -o tsv
    Check $check "Log Analytics Workspace does not exist"
}

function AzCheckMonitoringAddon
{
    $check = (AzAksCurrentQuery "show" -q "addonProfiles.omsagent.enabled" -o tsv) -eq "true"
    Check $check "Monitoring Addon has not been added"
}