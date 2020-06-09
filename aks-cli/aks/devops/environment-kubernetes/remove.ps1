param($environment, $namespace)

WriteAndSetUsage "aks devops environment-kubernetes remove" ([ordered]@{
    "<environment>" = "Environment Name"
    "<namespace>" = "Kubernetes namespace"
})

CheckCurrentCluster
CheckVariable $environment "environment name"
KubectlCheckNamespace $namespace

$environmentId = AzDevOpsEnvironmentId $environment
$resourceId = AzDevOpsResourceId $namespace

AzDevOpsInvokeCommand -a environments -r kubernetes -p "environmentId=$environmentId resourceId=$resourceId" -m DELETE

while (!$serviceEndpointId){
    $serviceEndpointId = AzDevOpsQuery "service-endpoint list" -q "[?name=='$environment-$namespace'].id" -o tsv
}

AksCommand devops service-connection delete $environment $namespace

# DELETE:
# DELETE https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234/providers/kubernetes/{id}