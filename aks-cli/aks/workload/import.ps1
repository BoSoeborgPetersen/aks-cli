param($regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "[regex]" = "Expression to match against name"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Loading Last-Applied-Config" -r $regex -n $namespace

$files = Get-ChildItem -Path /app/mapped/last-applied/ | ForEach-Object { $_.FullName }

Write-Verbose "Files: $files"

foreach($file in $files)
{
    Write-Info "Applying Last-Applied-Config from file '$file'"

    KubectlCommand "apply -f $file"
}