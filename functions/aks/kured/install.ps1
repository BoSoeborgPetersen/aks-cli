WriteAndSetUsage "aks kured install"

CheckCurrentCluster

Write-Info "Installing Kured (KUbernetes REboot Daemon)"

KubectlCommand "create ns kured"
Helm3Command "install kured stable/kured --namespace kured --set nodeSelector.`"beta\.kubernetes\.io/os`"=linux"