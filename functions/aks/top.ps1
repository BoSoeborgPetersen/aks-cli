param($type, $regex, $namespace)

$usage = Write-Usage "aks top <type> [regex] [namespace]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
    "no|node|nodes" = "Show Resource Utilization for Nodes."
    "po|pod|pods" = "Show Resource Utilization for Pods."
} -multiKey

$namespaceString = CreateNamespaceString $namespace

Write-Info "Show resource utilization of '$type' matching '$regex' in namespace '$namespace'"

$input = ExecuteQuery "kubectl top $type $namespaceString $kubeDebugString"

$output = ($input | Select-Object -Skip 1) | Where-Object { $_ -match "^$regex" }
($input[0..0] + $output)