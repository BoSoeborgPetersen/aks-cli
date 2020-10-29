param($name, $namespace = "default")

WriteAndSetUsage ([ordered]@{
    "<name>" = "Service Connection Name"
    "[namespace]" = "Kubernetes namespace"
})

CheckVariable $name "name"
KubectlCheckNamespace $namespace

$serviceAccount = DevOpsServiceAccountName $name
$roleBinding = DevOpsRoleBindingName $name

Write-Info "Checking DevOps Service Connection"

Write-Info "Checking Kubernetes service account"
KubectlCheck serviceaccount $serviceAccount $namespace -exit
Write-Info "Kubernetes service account exists"

Write-Info "Checking Kubernetes role binding"
KubectlCheck rolebinding $roleBinding $namespace -exit
Write-Info "Kubernetes role binding exists"

Write-Info "Checking DevOps service endpoint"
AzDevOpsCheck service-endpoint $name $namespace -exit
Write-Info "DevOps service endpoint exists"

Write-Info "DevOps Service Connection exists"