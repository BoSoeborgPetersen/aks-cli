param($type, $regex, $index = 0, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "<type>" = "Kubernetess resource type"
    "[regex]" = "Expression to match against name"
    "[index]" = "Index of the pod to open shell in"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
CheckKubectlCommand $type "Describe"
CheckVariable $regex "regex"
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

$namespace, $name = KubectlGetRegex -t $type -r $regex -i $index -n $namespace

Write-Info "Describe resource '$name' of type '$type'" -r $regex -i $index -n $namespace

KubectlCommand "describe $type $name" -n $namespace