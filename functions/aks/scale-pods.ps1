param($count, $deployment, $namespace)

WriteAndSetUsage "aks scale-pods <count> [deployment] [namespace]"

VerifyCurrentCluster
ValidateNumberRange ([ref]$count) "count" 0 100
DeploymentChoiceMenu ([ref]$deployment)
$namespaceString = KubectlNamespaceString $namespace

KubectlVerifyDeployment $deployment $namespace

Write-Info "Scaling number of pods to '$count', for deployment '$deployment' in namespace '$namespace'"

ExecuteCommand "kubectl scale --replicas $count deploy/$deployment $namespaceString $kubeDebugString"