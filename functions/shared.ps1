

# TODO: Try to show menu on error or debug stream instead of output stream.
function ChooseAzureSubscription()
{
    if(!$GlobalSubscriptions){
        $global:GlobalSubscriptions = az account list | ConvertFrom-Json
    }
    if ($GlobalSubscriptions.length -eq 1)
    {
        return $GlobalSubscriptions[0]
    }
    if ($GlobalSubscriptions.length -eq 0)
    {
        Write-Error "No Azure subscriptions"
        exit
    }
    $currentSubscription = menu @($GlobalSubscriptions | Foreach-Object { $_.name }) -ReturnIndex
    return $GlobalSubscriptions[$currentSubscription]
}

# TODO: Try to show menu on error or debug stream instead of output stream.
# TODO: Handle no choosen Azure Subscription.
function ChooseAksCluster()
{
    if (!$GlobalSubscriptionUsedForClusters -or !$GlobalClusters -or ($GlobalCurrentSubscription -ne $GlobalSubscriptionUsedForClusters))
    {
        $global:GlobalSubscriptionUsedForClusters = $GlobalCurrentSubscription
        $global:GlobalClusters = az aks list | ConvertFrom-Json
    }
    if ($GlobalClusters.length -eq 1)
    {
        return $GlobalClusters[0]
    }
    if ($GlobalClusters.length -eq 0)
    {
        Write-Error "No AKS clusters in Azure subscription"
        exit
    }
    $currentClusterIndex = menu @($GlobalClusters | Foreach-Object { $_.name }) -ReturnIndex
    return $GlobalClusters[$currentClusterIndex]
}

# TODO: Try to show menu on error or debug stream instead of output stream.
# TODO: Handle no choosen Azure Subscription.
# TODO: Handle no choosen AKS cluster.
# TODO: Add namespace parameter.
function ChooseKubernetesDeploymentName()
{
    if (!$GlobalSubscriptionUsedForDeployments -or !$GlobalClusterUsedForDeployments -or !$GlobalDeploymentNames -or ($GlobalCurrentSubscription -ne $GlobalSubscriptionUsedForDeployments) -or ($GlobalCurrentCluster -ne $GlobalClusterUsedForDeployments))
    {
        $global:GlobalSubscriptionUsedForDeployments = $GlobalCurrentSubscription
        $global:GlobalClusterUsedForDeployments = $GlobalCurrentCluster
        $global:GlobalDeploymentNames = (ExecuteQuery "kubectl get deploy -o jsonpath='{.items[*].metadata.name}'") -split ' '
    }
    if ($GlobalDeploymentNames.length -eq 1)
    {
        return $GlobalDeploymentNames[0]
    }
    if ($GlobalDeploymentNames.length -eq 0)
    {
        Write-Error "No Kubernetes deployments in AKS cluster"
        exit
    }
    return menu $GlobalDeploymentNames
}

function DeploymentChoiceMenu([ref] $deploymentName)
{
    if (!$deploymentName.Value)
    {
        Clear-Host
        Write-Info "Choose AKS Deployment: "
        $deploymentName.Value = ChooseKubernetesDeploymentName
    }
}

function ChooseAksDeployment()
{
    Clear-Host
    Write-Info "Choose AKS Deployment: "
    $global:GlobalDeploymentName = ChooseKubernetesDeploymentName
}

function VerifyCurrentSubscription($usage)
{
    if (!$GlobalCurrentSubscription) {
        Write-Info $usage
        Write-Error "No current Azure subscription, run 'aks switch subscription' to select a current Azure subscription"
        exit
    }
}

function VerifyCurrentCluster($usage)
{
    if (!$GlobalCurrentCluster) {
        Write-Info $usage
        Write-Error "No current AKS cluster, run 'aks switch cluster' to select a current AKS cluster"
        exit
    }
}

function VerifyCurrentClusterOrVariable($usage, $variable, $variableName)
{
    if (!$GlobalCurrentCluster -and $variable) {
        Write-Info $usage
        Write-Error "The following argument is required: $variableName"
        Write-Error "Alternatively run 'aks switch' to select a current AKS cluster, then the current cluster '$variableName' will be used"
        exit
    }
}

function VerifyDeployment($deploymentName, $namespace)
{
    if ($deploymentName)
    {
        $namespaceString = CreateNamespaceString $namespace
        $deployments = ExecuteQuery ("kubectl get deploy $namespaceString -o jsonpath='{.items[*].metadata.name}' $kubeDebugString")
        $deployment = $deployments.Split(' ') | Where-Object { $_ -eq $deploymentName }

        if (!$deployment)
        {
            Write-Info "Deployment '$deploymentName' in namespace '$namespace' does not exist!"
            exit
        }
    }
}

function VerifyVariable($usage, $variable, $variableName)
{
    if (!$variable) {
        Write-Info $usage
        Write-Error "The following argument is required: <$variableName>"
        exit
    }
}

function VerifyVersion($version)
{
    if (!($version -match "^[\d]+(\.[\d]+)?(\.[\d]+)?$"))
    {
        Write-Error "The specified version '$version' is not a valid Semantic Version (e.g. '0.14')"
        exit
    }
}

function CheckLocationExists($location)
{
    $locationExists = ExecuteQuery "az account list-locations --query `"[?name=='$location'].name`" -o tsv"
    if (!$locationExists)
    {
        Write-Error "Location '$location' does not exist"
        exit
    }
}

function CheckVersionExists($version, $preview)
{
    VerifyVersion $version

    $previewString = ConditionalOperator (!$preview) "!isPreview &&"

    $versionExists = ExecuteQuery "az aks get-upgrades -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query `"controlPlaneProfile.upgrades[?$previewString kubernetesVersion=='$version'].kubernetesVersion`" -o tsv"

    if (!$versionExists)
    {
        Write-Error "Version '$version' does not exist"
        exit
    }
}

function SetDefaultIfEmpty([ref] $variable, $defaultValue)
{
    if (!$variable.Value){
        $variable.Value = $defaultValue
    }
}

function ValidateNumberType($usage, [ref] $variable, $variableName)
{
    if (!($variable.Value -match "^\d+$")){
        Write-Info $usage
        Write-Error "Invalid variable <$variableName>, not a valid number '$($variable.Value)'"
        exit
    }
    $variable.Value = [int]$variable.Value
}

function ValidateNumberRange($usage, [ref] $variable, $variableName, $min, $max)
{
    VerifyVariable $usage $variable.Value $variableName
    ValidateOptionalNumberRange $usage $variable $variableName $min $max
}

function ValidateOptionalNumberRange($usage, [ref] $variable, $variableName, $min, $max)
{
    if($variable.Value)
    {
        ValidateNumberType $usage $variable $variableName
    
        $valid = ($variable.Value -ge $min -and $variable.Value -le $max)
        if (!$valid){
            Write-Info $usage
            Write-Error "Invalid variable <$variableName>, value outside range ($min - $max)"
            exit
        }
    }
}

function ValidateBooleanType($usage, $variable, $variableName){
    if (!($variable -match "^(FALSE|TRUE|False|True|false|true|0|1)$")){
        Write-Info $usage
        Write-Error ("$($variableName): Not a boolean '$variable'")
        exit
    }
}

function ExecuteCommand($commandString)
{
    if(!$dryrun)
    {
        Write-Verbose "COMMAND: $CommandString"
        
        return Invoke-Expression $CommandString
    }
    else 
    {
        Write-Info "WhatIf: $CommandString"
    }
}

function ExecuteQuery($commandString)
{
    Write-Verbose "QUERY: $CommandString"
    
    return Invoke-Expression $CommandString
}

function PrependWithDash($name, $prefix)
{
    if ($prefix)
    {
        return "$prefix-$name"
    }
    else 
    {
        return $name
    }
}

function CreateNamespaceString($namespace)
{
    $namespaceString = ""
    if ($namespace)
    {
        $namespaceString = "-n $namespace"
    }
    return $namespaceString
}

function ConditionalOperator($test, $value1, $value2 = "")
{
    $variable = $value2
    if ($test)
    {
        $variable = $value1
    }
    return $variable
}

function ArrayTakeIndexOrFirst($resourceNames, $index)
{
    if ($index)
    {
        return $resourceNames | Select-Object -Index ($index - 1)
    }
    else 
    {
        return $resourceNames | Select-Object -First 1
    }
}

function KubectlRegexMatchAll($usage, $type, $regex, $namespaceString)
{
    $resourceNamesString = ExecuteQuery "kubectl get $type -o jsonpath='{.items[*].metadata.name}' $namespaceString" 
    return $resourceNamesString -split ' ' | Where-Object { $_ -match "^$regex" }
}

function KubectlRegexMatch($usage, $type, $regex, $namespace, $index)
{
    $namespaceString = CreateNamespaceString $namespace
    $resourceNames = KubectlRegexMatchAll $usage $type $regex $namespaceString
    ValidateOptionalNumberRange $usage ([ref]$index) "index" 1 ($resourceNames.Length + 1)
    $resourceName = ArrayTakeIndexOrFirst $resourceNames $index

    if (!$resourceName)
    {
        Write-Error "No $type matching '$regex' in namespace '$namespace'"
        exit
    }
    
    return $resourceName
}

function KubectlGetPods($deployment, $namespace)
{
    $namespaceString = CreateNamespaceString $namespace
    return ExecuteQuery "kubectl get po -l app=$deployment -o jsonpath='{.items[*].metadata.name}' $namespaceString $kubeDebugString"
}

function KubectlGetPod($usage, $deployment, $namespace, $index)
{
    $pods = (KubectlGetPods $deployment $namespace) -split " "
    ValidateNumberRange $usage ([ref] $index) "index" 1 $pods.length
    return $pods | Select-Object -Index ($index - 1)
}

function AreYouSure()
{
    Write-Host ''
    $esc = "$([char]27)"
    $Red = "$esc[31m"
    $question = '{0}{1}' -f $Red, 'Are you sure you want to proceed?'
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice("", $question, $choices, 1)
    Write-Host ''

    return $decision -eq 0
}