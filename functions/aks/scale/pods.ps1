param($count, $deployment, $namespace)

WriteAndSetUsage "aks scale pods <count> [deployment] [namespace]"

CheckCurrentCluster
CheckNumberRange ([ref]$count) "count" -min 1 -max 100
DeploymentChoiceMenu ([ref]$deployment) $namespace
KubectlCheckDeployment $deployment $namespace
$namespaceString = KubectlNamespaceString $namespace

Write-Info "Scaling number of pods to '$count', for deployment '$deployment' in namespace '$namespace'"

ExecuteCommand "kubectl scale --replicas $count deploy/$deployment $namespaceString $kubeDebugString"