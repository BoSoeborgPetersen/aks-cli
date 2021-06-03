param([switch] $skipNamespace, [switch] $upgrade)

WriteAndSetUsage ([ordered]@{
    "[-skipNamespace]" = "Skip Namespace creation"
})

CheckCurrentCluster
$deployment = VpaDeploymentName

$operationName = ConditionalOperator $upgrade "Upgrading" "Installing"
Write-Info "$operationName Vertical Pod Autoscaler"

if (!$skipNamespace)
{
    KubectlCommand "create ns $deployment"
}
$operation = ConditionalOperator $upgrade "upgrade" "install"
HelmCommand "$operation $deployment cowboysysop/vertical-pod-autoscaler --set nodeSelector.`"kubernetes\.io/os`"=linux" -n $deployment