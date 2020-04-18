# TODO: Verify resource type, just like with describe and get (move it to shared.ps1).
# TODO: Add multi-choice commands (e.g. "po|pod|pods").
param($resourceType, $resourceName, $namespace)

$usage = Write-Usage "aks edit <resource type> <resource name> [namespace]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$namespace) "default"
VerifyVariable $usage $resourceType "resource type"
VerifyVariable $usage $resourceName "resource name"

Write-Info ("Edit '$resourceType/$resourceName' in namespace '$namespace'")

ExecuteCommand ("Set-Item -Path Env:KUBE_EDITOR -Value nano")
ExecuteCommand ("kubectl edit $resourceType $resourceName -n $namespace")