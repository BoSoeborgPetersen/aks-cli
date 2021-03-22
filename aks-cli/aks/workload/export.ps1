param($regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "[regex]" = "Expression to match against name"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Saving Last-Applied-Config" -r $regex -n $namespace

$types = $('Service','Deployment','HorizontalPodAutoscaler','Issuer','Ingress', 'CronJob', 'ScaledObject')

Write-Verbose "Types: $types"

foreach($type in $types)
{
    Write-Info "Getting names of type '$type'" -r $regex -n $namespace

    $names = (KubectlQuery "get $type" -j "{$.items[?(@.metadata.name!='kubernetes')].metadata.name}" -r $regex -n $namespace -o json) -split ' '

    Write-Verbose "Names: $names"

    foreach($name in $names)
    {
        KubectlSaveLastApplied $type $name $namespace
    }
}

KubectlSaveLastApplied Secret keda-metric-connectionstring-secret default