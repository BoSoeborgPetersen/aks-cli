param($name, $namespace)

Write-Verbose "QUERY: az devops service-endpoint list --query `"[?name=='$name-$namespace']`" $debugString"
az devops service-endpoint list --query "[?name=='$name-$namespace']"