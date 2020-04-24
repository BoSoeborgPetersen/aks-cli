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
function ChooseKubernetesDeployment($namespace)
{
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
    if ($GlobalDeploymentNames.length -eq 0)
    {
        Write-Error "No Kubernetes deployments in AKS cluster"
        exit
    }
    return menu $GlobalDeploymentNames
}

function DeploymentChoiceMenu([ref] $deployment, $namespace)
{
    if (!$deployment.Value)
    {
        Clear-Host
        Write-Info "Choose AKS Deployment: "
        $deployment.Value = ChooseKubernetesDeployment $namespace
    }
}