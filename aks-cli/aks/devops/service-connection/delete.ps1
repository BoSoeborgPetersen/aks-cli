param($name, $namespace = "default")

WriteAndSetUsage "aks devops service-connection delete" ([ordered]@{
    "<name>" = "Service Connection Name"
    "[namespace]" = "Kubernetes namespace"
})

CheckVariable $name "name"
KubectlCheckNamespace $namespace

Write-Info "Deleting Service Connection"

$serviceAccount = DevOpsServiceAccountName $name
$roleBinding = DevOpsRoleBindingName $name

KubectlCommand "delete serviceaccount $serviceAccount" -n $namespace
KubectlCommand "delete rolebinding $roleBinding" -n $namespace

$id = AzDevOpsQuery "service-endpoint list" -q "[?name=='$name-$namespace'].id" -o tsv
AzDevOpsCommand "service-endpoint delete --id $id -y"