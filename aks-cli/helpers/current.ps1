function ChooseSubscriptionMenu()
{
    if (!$GlobalSubscriptions)
    {
        $global:GlobalSubscriptions = az account list --all | ConvertFrom-Json | Sort-Object -Property Name
    }
    if ($GlobalSubscriptions.length -eq 1)
    {
        return $GlobalSubscriptions[0]
    }
    
    Check ($GlobalSubscriptions.length -gt 0) "No Azure subscriptions"

    $currentSubscription = Show-Menu @($GlobalSubscriptions | Foreach-Object { $_.name }) -ReturnIndex
    return $GlobalSubscriptions[$currentSubscription]
}

function SwitchCurrentSubscription([switch] $clear)
{
    if ($clear)
    {
        Clear-Host
    }
    Write-Info "Choose Azure Subscription: "

    $global:GlobalCurrentSubscription = ChooseSubscriptionMenu
    
    az account set -s $GlobalCurrentSubscription.name
}

function CheckCurrentSubscription()
{
    $check = $GlobalCurrentSubscription -or ($params[0] -eq "switch")
    Check $check "No current Azure subscription, run 'aks switch subscription' to select a current Azure subscription"
}

function GetCurrentSubscription()
{
    return $GlobalCurrentSubscription.id
}

function GetCurrentSubscriptionName()
{
    return $GlobalCurrentSubscription.name
}

function GetCurrentSubscriptionTenantId()
{
    return $GlobalCurrentSubscription.TenantId
}

function GetCurrentSubscriptionFqdn()
{
    return $GlobalCurrentSubscription.Fqdn
}

function ChooseClusterMenu([switch] $refresh = $false)
{
    Check $GlobalCurrentSubscription "No Azure subscriptions"

    if ($refresh -or !$GlobalSubscriptionUsedForClusters -or !$GlobalClusters -or ($GlobalCurrentSubscription -ne $GlobalSubscriptionUsedForClusters))
    {
        $global:GlobalSubscriptionUsedForClusters = $GlobalCurrentSubscription
        $global:GlobalClusters = az aks list | ConvertFrom-Json | Sort-Object -Property Name
    }
    if ($GlobalClusters.length -eq 1)
    {
        return $GlobalClusters[0]
    }

    Check ($GlobalClusters.length -gt 0) "No AKS clusters in Azure subscription"

    $currentClusterIndex = Show-Menu @($GlobalClusters | Foreach-Object { $_.name }) -ReturnIndex
    return $GlobalClusters[$currentClusterIndex]
}

function SwitchCurrentCluster([switch] $clear = $false, [switch] $refresh = $false)
{
    if ($clear)
    {
        Clear-Host
    }
    Write-Info "Choose Kubernetes Cluster: "

    $global:GlobalCurrentCluster = ChooseClusterMenu -refresh $refresh

    AzAksCurrentCommand 'get-credentials > $1'

    UpdateShellWindowTitle
    UpdateShellPrompt
    
    if ($clear)
    {
        Clear-Host
    }
}

function SwitchCurrentClusterTo($resourceGroup)
{
    $cluster = ResourceGroupToClusterName $resourceGroup
    $global:GlobalSubscriptionUsedForClusters = $GlobalCurrentSubscription
    $global:GlobalClusters = az aks list | ConvertFrom-Json
    $global:GlobalCurrentCluster = $GlobalClusters | Where-Object { $_.name -match $cluster }

    AzAksCurrentCommand "get-credentials"

    UpdateShellWindowTitle
    UpdateShellPrompt
}

function CheckCurrentCluster()
{
    Check $GlobalCurrentCluster "No current AKS cluster, run 'aks switch -cluster' to select a current AKS cluster"
}

function CheckCurrentClusterOrVariable($variable, [string] $variableName)
{
    $check = $GlobalCurrentCluster -or $variable
    Check $check ("The following argument is required: $variableName" + "\n" + "Alternatively run 'aks switch' to select a current AKS cluster, then the current cluster '$variableName' will be used")
}

function GetCurrentClusterResourceGroup()
{
    return $global:GlobalCurrentCluster.ResourceGroup
}

function global:GetCurrentClusterName()
{
    return $global:GlobalCurrentCluster.Name
}

function GetCurrentClusterLocation()
{
    return $global:GlobalCurrentCluster.Location
}

function SetCurrentCluster($cluster)
{
    $global:GlobalCurrentCluster = $cluster
}

function ChooseDeploymentMenu($namespace)
{
    Check $GlobalCurrentSubscription "No Azure subscriptions"
    Check $GlobalCurrentCluster "No AKS clusters in Azure subscription"

    if (!$GlobalSubscriptionUsedForDeployments -or !$GlobalClusterUsedForDeployments -or !$GlobalDeploymentNames -or ($GlobalCurrentSubscription -ne $GlobalSubscriptionUsedForDeployments) -or ($GlobalCurrentCluster -ne $GlobalClusterUsedForDeployments))
    {
        $global:GlobalSubscriptionUsedForDeployments = $GlobalCurrentSubscription
        $global:GlobalClusterUsedForDeployments = $GlobalCurrentCluster
        $namespaceString = KubectlNamespaceString $namespace
        $global:GlobalDeploymentNames = (ExecuteQuery "kubectl get deploy -o jsonpath='{.items[*].metadata.name}' $namespaceString") -split ' '
    }
    if ($GlobalDeploymentNames.length -eq 1)
    {
        return $GlobalDeploymentNames[0]
    }

    Check ($GlobalDeploymentNames.length -gt 0) "No Kubernetes deployments in AKS cluster"

    return Show-Menu $GlobalDeploymentNames
}

function ChooseDeployment([ref] $deployment, $namespace)
{
    if (!$deployment.Value)
    {
        Write-Info "Choose AKS Deployment: "
        $deployment.Value = ChooseDeploymentMenu $namespace
    }
}

function SetCurrentCommandText($text)
{
    $global:GlobalCurrentCommandText = $text
}

function GetCurrentCommandText()
{
    return $global:GlobalCurrentCommandText
}