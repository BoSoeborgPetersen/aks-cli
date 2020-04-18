$usage = Write-Usage "aks nginx purge [deployment name]"

VerifyCurrentCluster $usage

if (AreYouSure)
{
    Write-Info ("Remove Nginx-Ingress namespace")

    ExecuteCommand "kubectl delete namespace ingress $kubeDebugString"
}