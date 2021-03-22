param([switch] $skipNamespace, [switch] $upgrade)

WriteAndSetUsage ([ordered]@{
    "[-skipNamespace]" = "Skip Namespace creation"
})

CheckCurrentCluster
$deployment = KedaDeploymentName

$operationName = ConditionalOperator $upgrade "Upgrading" "Installing"
Write-Info "$operationName Keda (Kubernetes Event-driven Autoscaling)"

if (!$skipNamespace)
{
    KubectlCommand "create ns $deployment"
}
$operation = ConditionalOperator $upgrade "upgrade" "install"
HelmCommand "$operation $deployment kedacore/keda --set nodeSelector.`"kubernetes\.io/os`"=linux" -n $deployment