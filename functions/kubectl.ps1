function KubectlNamespaceString($namespace)
{
    return ConditionalOperator $namespace "-n $namespace" ""
}

function KubectlCheckDeployment($deploymentName, $namespace)
{
    if ($deploymentName)
    {
        $namespaceString = KubectlNamespaceString $namespace
        $deployments = ExecuteQuery ("kubectl get deploy $namespaceString -o jsonpath='{.items[*].metadata.name}' $kubeDebugString")
        $deployment = $deployments.Split(' ') | Where-Object { $_ -eq $deploymentName }

        Check $deployment "Deployment '$deploymentName' in namespace '$namespace' does not exist!"
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
    CheckOptionalNumberRange $index "index" 1 ($resourceNames.Length + 1)
    $resourceName = ArrayTakeIndexOrFirst $resourceNames $index

    Check $resourceName "No $type matching '$regex' in namespace '$namespace'"
    
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
    CheckNumberRange ([ref] $index) "index" -min 1 -max $pods.length
    return $pods | Select-Object -Index ($index - 1)
}