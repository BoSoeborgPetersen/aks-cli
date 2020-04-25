param($type, $regex, $namespace)

WriteAndSetUsage "aks top <type> [regex] [namespace]"

CheckCurrentCluster

CheckNoScriptSubCommand @{
    "no|node|nodes" = "Show Resource Utilization for Nodes."
    "po|pod|pods" = "Show Resource Utilization for Pods."
} -multiKey

$namespaceString = KubectlNamespaceString $namespace

Write-Info "Show resource utilization of '$type' matching '$regex' in namespace '$namespace'"

$input = ExecuteCommand "kubectl top $type $namespaceString $kubeDebugString"

$output = ($input | Select-Object -Skip 1) | Where-Object { $_ -match "^$regex" }
($input[0..0] + $output)