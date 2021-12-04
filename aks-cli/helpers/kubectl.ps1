function KubectlCommand($command, $regex, $namespace, $output, $jsonPath, $postFix)
{
    $regexString = ConditionalOperator $regex " | sed -E -n '1p;/$regex/p' "
    $namespaceString = KubectlNamespaceString $namespace
    $outputString = ConditionalOperator $output " -o $output"
    $outputString = ConditionalOperator $jsonPath " -o jsonpath=`"$jsonPath`""

    ExecuteCommand ("kubectl $command" + $namespaceString + $outputString + $kubeDebugString + $regexString + $postFix)
}

function KubectlQuery($command, $regex, $namespace, $output, $jsonPath, $postFix)
{
    $regexString = ConditionalOperator $regex " | grep -E $regex -i"
    $namespaceString = KubectlNamespaceString $namespace
    $outputString = ConditionalOperator $output " -o $output"
    $outputString = ConditionalOperator $jsonPath " -o jsonpath=`"$jsonPath`"" $outputString

    return ExecuteQuery ("kubectl $command" + $namespaceString + $outputString + $kubeDebugString + $regexString + $postFix)
}

function KubectlCheck($type, $name, $namespace, [switch] $exit)
{
    $namespaceString = KubectlNamespaceString $namespace

    $check = ExecuteQuery ("kubectl get $type $name" + $namespaceString + $kubeDebugString + " --ignore-not-found")

    if (!$check) {
        Write-Error "Resource '$name' of type '$type' does not exist" -n $namespace
    }

    if ($exit)
    {
        exit
    }
}

# LaterDo: Check standard error, instead of standard out, otherwise, if one resource exists, the error message is not shown, even though it should be.
function KubectlCheckYaml($file)
{
    $check = ExecuteQuery "kubectl get -f $file" + $kubeDebugString + " --ignore-not-found"

    if (!$check) {
        Write-Error "Resources in file '$file' do not exist"
    }
}

function KubectlClearConfig($resourceGroup)
{
    $cluster = ClusterName -resourceGroup $resourceGroup
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
    return ConditionalOperator ($namespace -eq "all") " -A" (ConditionalOperator $namespace " -n $namespace")
}

function KubectlCheckNamespace($name)
{
    $check = (!$name) -or ($name -eq "all") -or (KubectlQuery "get ns" -j "{$.items[?(@.metadata.name=='$name')].metadata.name}")
    
    Check $check "Namespace '$name' does not exist!"
}

function KubectlCheckDeployment($name, $namespace)
{
    if (!$name)
    {
        $name = ChooseDeployment $name $namespace
    }

    $check = KubectlQuery "get deploy" -n $namespace -j "{$.items[?(@.metadata.name=='$name')].metadata.name}"
    Check $check "Deployment '$name' in namespace '$namespace' does not exist!"

    return $name
}

function KubectlCheckDaemonSet($name, $namespace)
{
    $check = KubectlQuery "get ds -l release=$name" -n $namespace -j '{.items[*].metadata.name}'
    Check $check "DaemonSet '$name' in namespace '$namespace' does not exist!"
}

function KubectlGetRegex($type, $regex, $index = 0, $namespace)
{
    $json = KubectlQuery "get $type" -n $namespace -o "json | jq '[ .items[] | .metadata | select(.name|test(\`"$regex.\`")) | \`"\(.namespace) \(.name)\`" ]'"
    $resourceCount = $json | jq 'length'
    
    Check ($resourceCount -gt 0) "No type '$type' matching '$regex' in namespace '$namespace'"
    CheckOptionalNumberRange $index "index" -max ($resourceCount - 1)
    
    $namespace,$name = ($json | jq -r ".[$index]").Split()
    return $namespace, $name
}

function KubectlGetPods($deployment, $namespace)
{
    $json = KubectlQuery "get po -l app=$deployment" -n $namespace -o "json | jq '[ .items[] | .metadata.name ]'"
    return $json | ConvertFrom-Json
}

function KubectlGetPod($deployment, $namespace, $index = 0)
{
    $pods = KubectlGetPods $deployment $namespace
    CheckOptionalNumberRange $index "index" -max ($pods.Length - 1)
    return $pods[$index]
}

function KubectlCheckPodAutoscaler($name, $namespace)
{
    $check = KubectlQuery "get hpa" -n $namespace -j "{$.items[?(@.metadata.name=='$name')].metadata.name}"
    Check $check "Horizontal Pod Autoscaler '$name' in namespace '$namespace' does not exist!"
}

function KubectlSaveLastApplied($type, $name, $namespace, $output = 'yaml', $filePath = '/app/temp/last-applied')
{
    if ($namespace)
    {
        $fullFilePath = "$filePath/$namespace-$name-$type.$output"
    }
    else
    {
        $fullFilePath = "$filePath/default-$name-$type.$output"
    }

    Write-Info "Saving '$type/$name' to '$fullFilePath'"
    
    if ( -not (Test-Path $filePath) ) 
    {
        mkdir -p $filePath
    }
    $lastApplied = KubectlQuery "apply view-last-applied $type $name" -o $output -n $namespace
    
    SaveFile $lastApplied $fullFilePath
}

function KubectlSaveHelmSecret($name, $version, $namespace, $output = 'json', $filePath = '/app/temp/helm-secret')
{
    $fullFilePath = "$filePath/sh.helm.release.v1.$name.v$version.$output"

    Write-Info "Saving '$name' to '$fullFilePath'"
    
    if ( -not (Test-Path $filePath) ) 
    {
        mkdir -p $filePath
    }
    $secret = KubectlQuery "get secret sh.helm.release.v1.$name.v$version" -o $output -n $namespace
    
    SaveFile $secret $fullFilePath
}

function KubectlCreateNamespace($name)
{
    $check = KubectlQuery "get ns" -j "{$.items[?(@.metadata.name=='$name')].metadata.name}"

    if (!$check)
    {
        KubectlCommand "create ns $namespace"
    }
}