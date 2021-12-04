param($regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "[regex]" = "Expression to match against name"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Loading Helm releases" -r $regex -n $namespace

$files = Get-ChildItem -Path /app/temp/helm-secret | ForEach-Object { $_.FullName }

Write-Verbose "Files: $files"

foreach($file in $files)
{
    Write-Info "Applying Helm release from file '$file'"

    $name = $file -replace '/app/temp/helm-secret/sh\.helm\.release\.v1\.([\w-]+)\.v\d+\.json', '$1'
    $version = $file -replace '/app/temp/helm-secret/sh\.helm\.release\.v1\.[\w-]+\.v(\d+)\.json', '$1'
    Write-Verbose "Name: $name"
    Write-Verbose "Version: $version"
    KubectlCommand "apply -f $file"
    HelmCommand "rollback $name $version"
}