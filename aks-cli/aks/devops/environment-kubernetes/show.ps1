param($environment, $namespace)

WriteAndSetUsage "aks devops environment-kubernetes show" ([ordered]@{
    "<environment>" = "Environment Name"
    "<namespace>" = "Kubernetes namespace"
})

CheckCurrentCluster
CheckVariable $environment "environment name"
KubectlCheckNamespace $namespace

$environmentId = AzDevOpsEnvironmentId $environment
# $resourceId = AzDevOpsResourceId $namespace

Write-Info "Showing Environment Kubernetes resource"

# AzDevOpsInvokeQuery -a environments -r kubernetes -p "environmentId=$environmentId resourceId=$resourceId"
# AzDevOpsInvokeQuery -a environments -r kubernetes -p "environmentId=$environmentId"
AzDevOpsInvokeQuery -a pipelines -r kubernetes -p "resourceType=environment resourceId=$environmentId"
# AzDevOpsInvokeQuery -a distributedtask -r kubernetes -p "environmentId=$environmentId"

# LIST:
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations?resourceType=environment&resourceId=234
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/providers/kubernetes?resourceType=environment&resourceId=234
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/providers/kubernetes?resourceType=environment&resourceId=234
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/kubernetes?resourceType=environment&resourceId=234
# GET https://dev.azure.com/3Shape/Identity/_apis/distributedtask/environments/234/providers/kubernetes
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234/providers/kubernetes
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234/providers/kubernetes

# GET https://dev.azure.com/3Shape/Identity/_apis/distributedtask/environments/providers/kubernetes?environmentId=234
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/providers/kubernetes?environmentId=234

# SHOW:
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations/233
# GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234/providers/kubernetes/290

# {
# "area": "environments",
# "id": "d86b72de-d240-4d6f-8d06-08c2d66b015d",
# "maxVersion": 6.0,
# "minVersion": 5.2,
# "releasedVersion": "0.0",
# "resourceName": "environments",
# "resourceVersion": 1,
# "routeTemplate": "{project}/_apis/pipelines/{resource}/{environmentId}"
# },

# {
# "area": "PipelinesChecks",
# "id": "86c8381e-5aee-4cde-8ae4-25c0c7f5eaea",
# "maxVersion": 6.0,
# "minVersion": 5.1,
# "releasedVersion": "0.0",
# "resourceName": "configurations",
# "resourceVersion": 1,
# "routeTemplate": "{project}/_apis/pipelines/checks/{resource}/{id}"
# },

# {
# "area": "environments",
# "id": "73fba52f-33ab-42b3-a538-ce67a9223b15",
# "maxVersion": 6.0,
# "minVersion": 5.2,
# "releasedVersion": "0.0",
# "resourceName": "kubernetes",
# "resourceVersion": 2,
# "routeTemplate": "{project}/_apis/pipelines/environments/{environmentId}/providers/{resource}/{resourceId}"
# },