param([switch] $skipNamespace)

WriteAndSetUsage ([ordered]@{
    "[-skipNamespace]" = "Skip Namespace creation"
})

CheckCurrentCluster
$deployment = KuredDeploymentName

Write-Info "Installing Kured (KUbernetes REboot Daemon)"

if (!$skipNamespace)
{
    KubectlCommand "create ns $deployment"
}
HelmCommand "install $deployment kured/kured --set nodeSelector.`"kubernetes\.io/os`"=linux" -n $deployment