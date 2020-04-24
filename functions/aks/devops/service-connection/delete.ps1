param($name, $namespace)

WriteAndSetUsage "aks devops service-connection delete <name> [namespace]"

VerifyVariable $name "name"
SetDefaultIfEmpty ([ref]$namespace) "default"
$namespaceString = KubectlNamespaceString $namespace

$unixName = ($name.ToLower() -replace ' - ',' ') -replace '\W','-'
$serviceAccountName = "$unixName-devops-sa"
$roleBindingName = "$unixName-devops-rb"

# Delete Service Account
ExecuteCommand ("kubectl delete serviceaccount $serviceAccountName $namespaceString $kubeDebugString")
# Delete Role Binding
ExecuteCommand ("kubectl delete rolebinding $roleBindingName $namespaceString $kubeDebugString")

$id = ExecuteQuery ("az devops service-endpoint list --query `"[?name=='$name'].id`" -o tsv $debugString")

ExecuteCommand ("az devops service-endpoint delete --id $id -y --project $teamName $debugString")