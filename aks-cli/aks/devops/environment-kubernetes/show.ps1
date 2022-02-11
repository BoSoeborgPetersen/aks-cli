param($environment, $namespace)

WriteAndSetUsage ([ordered]@{
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
# AzDevOpsInvokeQuery -a environments -r environments -p "environmentId=$id"
# AzDevOpsInvokeQuery -a environments -r kubernetes -p "environmentId=$environmentId"
AzDevOpsInvokeQuery -a environments -r kubernetes
# AzDevOpsInvokeQuery -a pipelines -r kubernetes -p "resourceType=environment resourceId=$environmentId"

# az devops invoke --area environments --resource environments --route-parameters project=PaymentServices --query-parameters environmentId=103 --http-method GET --api-version 7.1-preview
# az devops invoke --area environments --resource kubernetes --route-parameters project=PaymentServices --query-parameters environmentId=2 --http-method GET --api-version 7.1-preview

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
#     "area": "environments",
#     "id": "d86b72de-d240-4d6f-8d06-08c2d66b015d",
#     "maxVersion": 7.1,
#     "minVersion": 5.2,
#     "releasedVersion": "0.0",
#     "resourceName": "environments",
#     "resourceVersion": 1,
#     "routeTemplate": "{project}/_apis/pipelines/{resource}/{environmentId}"
#   },

# {
#     "area": "environments",
#     "id": "73fba52f-33ab-42b3-a538-ce67a9223b15",
#     "maxVersion": 7.1,
#     "minVersion": 5.2,
#     "releasedVersion": "0.0",
#     "resourceName": "kubernetes",
#     "resourceVersion": 2,
#     "routeTemplate": "{project}/_apis/pipelines/environments/{environmentId}/providers/{resource}/{resourceId}"
#   },