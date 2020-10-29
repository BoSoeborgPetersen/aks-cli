param($name, $namespace = "default")

WriteAndSetUsage ([ordered]@{
    "<name>" = "Service Connection Name"
    "[namespace]" = "Kubernetes namespace"
})

CheckVariable $name "name"
KubectlCheckNamespace $namespace

Write-Info "Showing Service Connection"

AzDevOpsCommand "service-endpoint list" -q "[?name=='$name-$namespace']"