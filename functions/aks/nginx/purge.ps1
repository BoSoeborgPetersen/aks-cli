WriteAndSetUsage "aks nginx purge [deployment name]"

VerifyCurrentCluster

Write-Info "Remove Nginx-Ingress namespace"

if (AreYouSure)
{
    ExecuteCommand "kubectl delete ns ingress $kubeDebugString"
}