param($count, $deployment, $namespace)

$usage = Write-Usage "aks scale-pods <count> [deployment] [namespace]"

VerifyCurrentCluster $usage
ValidateNumberRange $usage ([ref]$count) "count" 0 100
DeploymentChoiceMenu ([ref]$deployment)
$namespaceString = CreateNamespaceString $namespace

VerifyDeployment $deployment $namespace

Write-Info "Scaling number of pods to '$count', for deployment '$deployment' in namespace '$namespace'"

ExecuteCommand "kubectl scale --replicas $count deploy/$deployment $namespaceString $kubeDebugString"