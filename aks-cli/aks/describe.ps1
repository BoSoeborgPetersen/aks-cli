# LaterDo: Check that "-allNamespaces" is not allowed.
param($type, $regex, $index, $namespace, [switch] $allNamespaces)

WriteAndSetUsage "aks describe <type> <regex> [index] [namespace] [-a/-allNamespaces]"

CheckCurrentCluster
CheckKubectlCommand $type "Describe"
CheckVariable $regex "regex"
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Describe '$type'" -r $regex -i $index -n $namespace

$resource = KubectlGetRegex $type $regex $namespace $index

KubectlCommand "describe $type $resource" -n $namespace