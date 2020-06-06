param($count, $deployment, $namespace)

WriteAndSetUsage "aks scale pods <count> [deployment] [namespace]"

CheckCurrentCluster
CheckNumberRange ([ref]$count) "count" -min 1 -max 100
KubectlCheckNamespace $namespace
KubectlCheckDeployment ([ref]$deployment) $namespace -showMenu

Write-Info "Scaling number of pods to '$count', for deployment '$deployment' in namespace '$namespace'"

KubectlCommand "scale --replicas $count deploy/$deployment" -n $namespace