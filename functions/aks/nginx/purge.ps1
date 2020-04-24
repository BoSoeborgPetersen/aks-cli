WriteAndSetUsage "aks nginx purge [deployment name]"

$namespace = "ingress"
CheckCurrentCluster

Write-Info "Remove Nginx namespace"

if (AreYouSure)
{
    ExecuteCommand "kubectl delete ns $namespace $kubeDebugString"
}