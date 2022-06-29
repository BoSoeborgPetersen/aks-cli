function SubscriptionMenu
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

function SwitchCurrentSubscription
{
    Clear-Host

    Write-Info "Choose Azure Subscription: "

    $global:GlobalCurrentSubscription = SubscriptionMenu
    
    az account set -s $GlobalCurrentSubscription.name
}

function CheckCurrentSubscription
{
    $check = $GlobalCurrentSubscription -or ($params[0] -eq "switch")
    Check $check "No current Azure subscription, run 'aks switch subscription' to select a current Azure subscription"
}

function CurrentSubscription
{
    return $GlobalCurrentSubscription.id
}

function CurrentSubscriptionName
{
    return $GlobalCurrentSubscription.name
}

function CurrentSubscriptionTenantId
{
    return $GlobalCurrentSubscription.TenantId
}

function ClusterMenu([switch] $refresh)
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

function SwitchCurrentCluster([switch] $clear, [switch] $refresh)
{
    Clear-Host

    Write-Info "Choose Kubernetes Cluster: "

    $global:GlobalCurrentCluster = ClusterMenu -refresh $refresh

    AzAksCurrentCommand 'get-credentials -a --overwrite-existing > $1'

    UpdateShellWindowTitle
    
    # if ($clear)
    # {
    #     Clear-Host
    # }
}

function SwitchCurrentClusterTo($resourceGroup)
{
    $cluster = ClusterName -resourceGroup $resourceGroup
    $global:GlobalSubscriptionUsedForClusters = $GlobalCurrentSubscription
    $global:GlobalClusters = az aks list | ConvertFrom-Json
    $global:GlobalCurrentCluster = $GlobalClusters | Where-Object { $_.name -match $cluster }

    AzAksCommand "get-credentials -g $resourceGroup -n $cluster -a"

    UpdateShellWindowTitle
}

function CheckCurrentCluster
{
    Check $GlobalCurrentCluster "No current AKS cluster, run 'aks switch -cluster' to select a current AKS cluster"
}

function CheckCurrentClusterOrVariable($variable, $variableName)
{
    $check = $GlobalCurrentCluster -or $variable
    Check $check ("The following argument is required: $variableName" + "`n" + "Alternatively run 'aks switch' to select a current AKS cluster, then the current cluster '$variableName' will be used")
}

function CurrentClusterResourceGroup
{
    return $global:GlobalCurrentCluster.ResourceGroup
}

function global:CurrentClusterName
{
    return $global:GlobalCurrentCluster.Name
}

function CurrentClusterLocation
{
    return $global:GlobalCurrentCluster.Location
}

function CurrentClusterFqdn
{
    return $GlobalCurrentCluster.Fqdn
}

function SetCurrentCluster($cluster)
{
    $global:GlobalCurrentCluster = $cluster
}

function DeploymentMenu($namespace)
{
    Check $GlobalCurrentSubscription "No Azure subscriptions"
    Check $GlobalCurrentCluster "No AKS clusters in Azure subscription"

    if (!$GlobalSubscriptionUsedForDeployments -or !$GlobalClusterUsedForDeployments -or !$GlobalDeployments -or ($GlobalCurrentSubscription -ne $GlobalSubscriptionUsedForDeployments) -or ($GlobalCurrentCluster -ne $GlobalClusterUsedForDeployments))
    {
        $global:GlobalSubscriptionUsedForDeployments = $GlobalCurrentSubscription
        $global:GlobalClusterUsedForDeployments = $GlobalCurrentCluster
        $global:GlobalDeployments = (KubectlQuery "get deploy" -n $namespace -j '{.items[*].metadata.name}') -split ' '
    }

    if ($GlobalDeployments.length -eq 1)
    {
        return $GlobalDeployments[0]
    }

    Check ($GlobalDeployments.length -gt 0) "No Kubernetes deployments in AKS cluster"

    return Show-Menu $GlobalDeployments
}

function ChooseDeployment($deployment, $namespace)
{
    if (!$deployment)
    {
        Write-Info "Choose AKS Deployment: "
        return (DeploymentMenu $namespace)
    }
}

function SetCurrentCommandText($text)
{
    $global:GlobalCurrentCommandText = $text
}

function CurrentCommandText
{
    return $global:GlobalCurrentCommandText
}

function SetCurrentUsage($usage)
{
    $global:GlobalCurrentUsage = $usage
}

function CurrentUsage
{
    return $global:GlobalCurrentUsage
}