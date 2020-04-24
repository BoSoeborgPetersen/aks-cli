param($deployment, $min, $max, $limit, $namespace)

WriteAndSetUsage "aks pod-autoscaler replace [deployment] [min] [max] [limit] [namespace]"

CheckCurrentCluster
CheckNumberRange ([ref]$min) "min" -min 1 -max 1000 -default 3
CheckNumberRange ([ref]$max) "max" -min 1 -max 1000 -default 6
CheckNumberRange ([ref]$limit) "limit" -min 40 -max 80 -default 50
DeploymentChoiceMenu ([ref]$deployment) $namespace
KubectlCheckDeployment $deployment $namespace

Write-Info "Replace pod autoscaler for deployment '$deployment'"

ExecuteCommand "aks pod-autoscaler remove $deployment $namespace"
ExecuteCommand "aks pod-autoscaler add $deployment $min $max $limit $namespace"