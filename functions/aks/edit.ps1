param($type, $name, $namespace)

$usage = Write-Usage "aks edit <resource type> <resource name> [namespace]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$namespace) "default"

Write-Info ("Edit '$type/$name' in namespace '$namespace' on current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("Set-Item -Path Env:KUBE_EDITOR -Value nano")
ExecuteCommand ("kubectl edit $type $name")