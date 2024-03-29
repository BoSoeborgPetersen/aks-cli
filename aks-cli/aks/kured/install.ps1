param([switch] $skipNamespace, [switch] $upgrade)

WriteAndSetUsage ([ordered]@{
    "[-skipNamespace]" = "Skip Namespace creation"
})

CheckCurrentCluster
$deployment = KuredDeploymentName

$operationName = ConditionalOperator $upgrade "Upgrading" "Installing"
Write-Info "$operationName Kured (KUbernetes REboot Daemon)"

if (!$skipNamespace)
{
    KubectlCommand "create ns $deployment"
}
$operation = ConditionalOperator $upgrade "upgrade" "install"
HelmCommand "$operation $deployment kured/kured --set nodeSelector.`"kubernetes\.io/os`"=linux" -n $deployment