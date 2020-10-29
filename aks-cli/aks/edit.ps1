param($type, $regex, $index = 0, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "<type>" = "Kubernetess resource type"
    "[regex]" = "Expression to match against name"
    "[index]" = "Index of the pod to open shell in"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
CheckKubectlCommand $type "Edit"
CheckVariable $regex "regex"
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

$namespace, $name = KubectlGetRegex -t $type -r $regex -i $index -n $namespace

Write-Info "Edit resource '$name' of type '$type'" -r $regex -i $index -n $namespace

KubectlCommand "edit $type $name" -n $namespace