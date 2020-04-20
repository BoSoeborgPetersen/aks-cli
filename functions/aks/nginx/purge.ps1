$usage = Write-Usage "aks nginx purge [deployment name]"

VerifyCurrentCluster $usage

Write-Info "Remove Nginx-Ingress namespace"

if (AreYouSure)
{
    ExecuteCommand "kubectl delete ns ingress $kubeDebugString"
}