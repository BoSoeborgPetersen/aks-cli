param($name, $namespace)

AzCommand "devops service-endpoint list" -q "`"[?name==$name-$namespace]`""
