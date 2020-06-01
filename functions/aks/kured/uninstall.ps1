WriteAndSetUsage "aks kured uninstall"

CheckCurrentCluster

Write-Info "Uninstalling Kured (KUbernetes REboot Daemon)"

if (AreYouSure)
{
    Helm3Command "uninstall kured --namespace kured"
    KubectlCommand "delete ns kured"
}