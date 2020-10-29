param($count, $deployment, $namespace)

WriteAndSetUsage ([ordered]@{
    "<count>" = "Number of pods"
    "[deployment]" = "Kubenetes deployment"
    "[namespace]" = KubernetesNamespaceDescription
})

CheckCurrentCluster
CheckNumberRange $count "count" -min 0 -max 100
KubectlCheckNamespace $namespace
$deployment = KubectlCheckDeployment $deployment $namespace

Write-Info "Scaling number of pods to '$count', for deployment '$deployment' in namespace '$namespace'"

KubectlCommand "scale --replicas $count deploy/$deployment" -n $namespace