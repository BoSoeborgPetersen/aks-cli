# TODO: Catch empty type or name and print message
param($resourceType, $resourceName, $namespace)

$usage = Write-Usage "aks edit <resource type> <resource name> [namespace]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$namespace) "default"

Write-Info ("Edit '$resourceType/$resourceName' in namespace '$namespace'")

ExecuteCommand ("Set-Item -Path Env:KUBE_EDITOR -Value nano")
ExecuteCommand ("kubectl edit $resourceType $resourceName")