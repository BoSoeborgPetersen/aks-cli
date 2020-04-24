WriteAndSetUsage "aks tiller uninstall"

VerifyCurrentCluster

Write-Info "Uninstalling Tiller (Helm server-side)"

if (AreYouSure)
{
    ExecuteCommand "kubectl delete deployment tiller-deploy -n kube-system $kubeDebugString"
    ExecuteCommand "kubectl delete clusterrolebinding tiller $kubeDebugString"
    ExecuteCommand "kubectl delete serviceaccount tiller -n kube-system $kubeDebugString"
}