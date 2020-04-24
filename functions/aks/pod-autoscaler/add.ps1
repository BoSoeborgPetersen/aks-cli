param($deployment, $min, $max, $limit, $namespace)

WriteAndSetUsage "aks pod-autoscaler add [deployment] [min] [max] [limit] [namespace]"

CheckCurrentCluster
CheckNumberRange ([ref]$min) "min" -min 1 -max 1000 -default 3
CheckNumberRange ([ref]$max) "max" -min 1 -max 1000 -default 30
CheckNumberRange ([ref]$limit) "limit" -min 40 -max 80 -default 60
DeploymentChoiceMenu ([ref]$deployment) $namespace
KubectlCheckDeployment $deployment $namespace
$namespaceString = KubectlNamespaceString $namespace

Write-Info "Add pod autoscaler (min: $min, max: $max, cpu limit: $limit) to deployment '$deployment' in namespace '$namespace'"

ExecuteCommand "kubectl autoscale deploy $deployment --cpu-percent=$limit --min=$min --max=$max $namespaceString $kubeDebugString"