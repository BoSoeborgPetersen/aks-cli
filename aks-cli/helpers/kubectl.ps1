function KubectlCommand($command, [string] $regex, [string] $namespace, [string] $postFix)
{
    $regexString = ConditionalOperator $regex "| grep -E $regex -i"
    $namespaceString = KubectlNamespaceString $namespace

    ExecuteCommand "kubectl $command $namespaceString $kubeDebugString $regexString $postFix"
}

function KubectlQuery($command, [string] $regex, [string] $namespace, [string] $output, [string] $postFix)
{
    $regexString = ConditionalOperator $regex "| grep -E $regex -i"
    $namespaceString = KubectlNamespaceString $namespace
    $outputString = ConditionalOperator $output "-o $output"

    return ExecuteQuery "kubectl $command $namespaceString $outputString $kubeDebugString $regexString $postFix"
}

function KubectlClearConfig([string] $resourceGroup)
{
    $cluster = ResourceGroupToClusterName $resourceGroup
    $contexts = KubectlQuery "config get-contexts" -o name

    if ($contexts.Where({ $_ -eq $cluster }, 'First').Count -gt 0)
    {
        KubectlCommand "config unset current-context"

        KubectlCommand "config delete-context $cluster"
        KubectlCommand "config delete-cluster $cluster"

        $username = "users.clusterUser_$resourceGroup_$cluster"
        
        KubectlCommand "config unset $username"
    }
}

function KubectlNamespaceString($namespace)
{
    return ConditionalOperator ($namespace -eq "all") "-A" (ConditionalOperator $namespace "-n $namespace" "")
}

function KubectlCheckNamespace($name)
{
    $check = ($name -eq "all") -or (!$name) -or (KubectlQuery "get ns" -o "jsonpath=`"{$.items[?(@.metadata.name=='$name')].metadata.name}`"")
    
    Check $check "Namespace '$name' does not exist!"
}

function KubectlCheckDeployment([ref] $name, $namespace, [switch] $showMenu)
{
    if (!$name.Value -and $showMenu)
    {
        ChooseDeployment $name $namespace
    }

    $check = KubectlQuery "get deploy" -n $namespace -o "jsonpath=`"{$.items[?(@.metadata.name=='$($name.Value)')].metadata.name}`""
    # LaterDo: Try to change to this.
    # $check = KubectlQuery "get deploy -l app=$($name.Value)" -n $namespace -o "jsonpath='{.items[*].metadata.name}'"

    Check $check "Deployment '$($name.Value)' in namespace '$namespace' does not exist!"
}

function KubectlCheckDaemonSet([ref] $name, $namespace, [switch] $showMenu)
{
    if (!$name.Value -and $showMenu)
    {
        ChooseDeployment $name $namespace
    }

    $check = KubectlQuery "get ds -l app=$($name.Value)" -n $namespace -o "jsonpath='{.items[*].metadata.name}'"

    Check $check "DaemonSet '$($name.Value)' in namespace '$namespace' does not exist!"
}

function KubectlGetAllRegex($type, $regex, $namespace)
{
    $resourceNamesString = KubectlQuery "get $type" -n $namespace -o "jsonpath='{.items[*].metadata.name}'"
    return $resourceNamesString -split ' ' | Where-Object { $_ -match "^$regex" }
}

function KubectlGetRegex($type, $regex, $namespace, $index)
{
    $resourceNames = KubectlGetAllRegex $type $regex $namespace
    CheckOptionalNumberRange $index "index" 1 $resourceNames.Length
    $resourceName = ArrayTakeIndexOrFirst $resourceNames $index

    Check $resourceName "No type '$type' matching '$regex' in namespace '$namespace'"
    
    return $resourceName
}

function KubectlGetPods($deployment, $namespace)
{
    $pods = KubectlQuery "get po -l app=$deployment" -n $namespace -o "jsonpath='{.items[*].metadata.name}'"
    return $pods -split " " | Where-Object { $_ -ne "" }
}

# LaterDo: The call to KubectlGetPods does not return an array when only 1 pod is found.
function KubectlGetPod($deployment, $namespace, $index)
{
    $pods = KubectlGetPods $deployment $namespace
    CheckNumberRange ([ref] $index) "index" -min 1 -max $pods.Length
    return $pods | Select-Object -Index ($index - 1)
}