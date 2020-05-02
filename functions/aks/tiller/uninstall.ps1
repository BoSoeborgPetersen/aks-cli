WriteAndSetUsage "aks tiller uninstall"

CheckCurrentCluster

Write-Info "Uninstalling Tiller (Helm server-side)"

if (AreYouSure)
{
    KubectlCommand "delete deployment tiller-deploy -n kube-system"
    KubectlCommand "delete clusterrolebinding tiller"
    KubectlCommand "delete serviceaccount tiller -n kube-system"
}