# LaterDo: Add "-allNamespaces" parameter.
param($type, $regex, $index, $namespace)

WriteAndSetUsage "aks edit <type> <regex> [index] [namespace]"

CheckCurrentCluster
CheckKubectlCommand $type "Edit"
CheckVariable $regex "regex"

Write-Info "Edit '$type'" -r $regex -i $index -n $namespace

$resource = KubectlGetRegex $type $regex $namespace $index

KubectlCommand "edit $type $resource" -n $namespace