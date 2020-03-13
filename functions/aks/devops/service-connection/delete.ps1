param($name, $namespace)

SetDefaultIfEmpty ([ref]$namespace) "default"

$unixName = ($name.ToLower() -replace ' - ',' ') -replace '\W','-'
$serviceAccountName = "$unixName-devops-sa"
$roleBindingName = "$unixName-devops-rb"

# Delete Service Account
ExecuteCommand ("kubectl delete serviceaccount $serviceAccountName -n $namespace $kubeDebugString")
# Delete Role Binding
ExecuteCommand ("kubectl delete rolebinding $roleBindingName -n $namespace $kubeDebugString")

$id = ExecuteQuery ("az devops service-endpoint list --query `"[?name=='$name'].id`" -o tsv $debugString")

ExecuteCommand ("az devops service-endpoint delete --id $id -y --project $teamName $debugString")