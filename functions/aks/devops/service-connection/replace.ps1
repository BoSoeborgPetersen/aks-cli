param($name, $namespace)

aks devops service-connection delete $name $namespace
aks devops service-connection create $name $namespace