# LaterDo: Rewrite
param($name, $namespace)

WriteAndSetUsage "aks devops service-connection delete <name> [namespace]"

CheckVariable $name "name"
SetDefaultIfEmpty ([ref]$namespace) "default"

$unixName = ($name.ToLower() -replace ' - ',' ') -replace '\W','-'
$serviceAccountName = "$unixName-devops-sa"
$roleBindingName = "$unixName-devops-rb"

# Delete Service Account
KubectlCommand "delete serviceaccount $serviceAccountName" -n $namespace
# Delete Role Binding
KubectlCommand "delete rolebinding $roleBindingName" -n $namespace

$id = AzQuery "devops service-endpoint list" -q "`"[?name==$name].id`"" -o tsv

AzCommand "devops service-endpoint delete --id $id -y --project $teamName"