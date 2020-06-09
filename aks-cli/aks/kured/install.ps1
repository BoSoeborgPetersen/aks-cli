param([switch] $skipNamespace)

WriteAndSetUsage "aks kured install" ([ordered]@{
    "[-skipNamespace]" = "Skip Namespace creation"
})

CheckCurrentCluster
$deployment = KuredDeploymentName

Write-Info "Installing Kured (KUbernetes REboot Daemon)"

if (!$skipNamespace)
{
    KubectlCommand "create ns $deployment"
}
HelmCommand "install $deployment kured/kured --set nodeSelector.`"beta\.kubernetes\.io/os`"=linux" -n $deployment