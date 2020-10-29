param($name, $namespace = "default")

WriteAndSetUsage ([ordered]@{
    "<name>" = "Service Connection Name"
    "[namespace]" = "Kubernetes namespace"
})

Write-Info "Replacing (delete, then create) Service Connection"

AksCommand devops service-connection delete $name $namespace
AksCommand devops service-connection create $name $namespace