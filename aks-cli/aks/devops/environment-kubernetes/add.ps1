param($environment, $namespace)

WriteAndSetUsage ([ordered]@{
    "<environment>" = "Environment Name"
    "<namespace>" = "Kubernetes namespace"
})

CheckCurrentCluster
CheckVariable $environment "environment name"
KubectlCheckNamespace $namespace

$serviceEndpoint = AksCommand devops service-connection create $environment $namespace
$serviceEndpointId = $serviceEndpoint | jq -r ' .id'

while (!$serviceEndpointId){
    $serviceEndpointId = AzDevOpsQuery "service-endpoint list" -q "[?name=='$environment-$namespace'].id" -o tsv
}

$arguments = @{
    name = $namespace
    namespace = $namespace
    clusterName = CurrentClusterName
    serviceEndpointId = $serviceEndpointId
}

$environmentId = AzDevOpsEnvironmentId $environment

$filepath = SaveTempFile $arguments
AzDevOpsInvokeCommand -a environments -r kubernetes -p "environmentId=$environmentId" -m POST -f $filepath
DeleteTempFile $filepath

# CREATE:
# POST https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234/providers/kubernetes