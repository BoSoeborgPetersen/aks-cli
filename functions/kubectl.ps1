function KubectlNamespaceString($namespace)
{
    $namespaceString = ""
    if ($namespace)
    {
        $namespaceString = "-n $namespace"
    }
    return $namespaceString
}

function KubectlVerifyDeployment($deploymentName, $namespace)
{
    if ($deploymentName)
    {
        $namespaceString = KubectlNamespaceString $namespace
        $deployments = ExecuteQuery ("kubectl get deploy $namespaceString -o jsonpath='{.items[*].metadata.name}' $kubeDebugString")
        $deployment = $deployments.Split(' ') | Where-Object { $_ -eq $deploymentName }

        if (!$deployment)
        {
            Write-Info "Deployment '$deploymentName' in namespace '$namespace' does not exist!"
            exit
        }
    }
}

function KubectlRegexMatchAll($type, $regex, $namespaceString)
{
    $resourceNamesString = ExecuteQuery "kubectl get $type -o jsonpath='{.items[*].metadata.name}' $namespaceString" 
    return $resourceNamesString -split ' ' | Where-Object { $_ -match "^$regex" }
}

function KubectlRegexMatch($type, $regex, $namespace, $index)
{
    $namespaceString = KubectlNamespaceString $namespace
    $resourceNames = KubectlRegexMatchAll $type $regex $namespaceString
    ValidateOptionalNumberRange ([ref]$index) "index" 1 ($resourceNames.Length + 1)
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
    $namespaceString = KubectlNamespaceString $namespace
    return ExecuteQuery "kubectl get po -l app=$deployment -o jsonpath='{.items[*].metadata.name}' $namespaceString $kubeDebugString"
}

function KubectlGetPod($deployment, $namespace, $index)
{
    $pods = (KubectlGetPods $deployment $namespace) -split " "
    ValidateNumberRange ([ref] $index) "index" 1 $pods.length
    return $pods | Select-Object -Index ($index - 1)
}