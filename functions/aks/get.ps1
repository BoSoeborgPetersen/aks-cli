param($type, $regex, $namespace)

WriteAndSetUsage "aks get <type> [regex] [namespace]"

CheckCurrentCluster
CheckKubectlCommand "Get"
$namespaceString = KubectlNamespaceString $namespace

if ($regex) 
{
    Write-Info "Get '$type' matching '$regex' in namespace '$namespace'"

    $input = ExecuteQuery "kubectl get $type $namespaceString $debugString"
    $output = ($input | Select-Object -Skip 1) | Where-Object { $_ -match "^$regex" }
    ($input[0..0] + $output)
}
else 
{
    Write-Info "Get all '$type' in namespace '$namespace'"

    ExecuteCommand "kubectl get $type $namespaceString $kubeDebugString"
}