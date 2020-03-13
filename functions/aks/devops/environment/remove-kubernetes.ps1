az devops configure --defaults organization=https://dev.azure.com/3Shape/
$envId = az devops invoke --area environments --resource environments --route-parameters project=Communicate --http-method GET --api-version 6.0-preview --query "value[?name=='TEST2'].id" -o tsv
"EnvID: $envId"
#$resourceId =  Invoke-RestMethod -Uri 'https://dev.azure.com/3Shape/Communicate/_environments/58?view=resources'
# $resourceId = az devops invoke --area environments --resource kubernetes --route-parameters project=Communicate environmentId=59 resourceId=130 --http-method GET --api-version 6.0-preview -o json
$resourceId = az devops invoke --area environments --resource kubernetes --route-parameters project=Communicate environmentId=59 --http-method GET --api-version 6.0-preview -o json --debug
# $resourceId = 130
"ResourceID: $resourceId"
#az devops invoke --area environments --resource kubernetes --route-parameters project=Communicate environmentId=$envId resourceId=$resourceId --http-method DELETE --api-version 6.0-preview -o json

# GET https://dev.azure.com/3Shape/Communicate/_environments/59?view=resources
# GET https://dev.azure.com/3Shape/Communicate/_apis/pipelines/environments
# GET https://dev.azure.com/3Shape/Communicate/_apis/pipelines/environments/59
# GET https://dev.azure.com/3Shape/Communicate/_apis/pipelines/environments/59/providers/kubernetes # Not working
# GET https://dev.azure.com/3Shape/Communicate/_apis/pipelines/environments/59/providers/kubernetes/130

#https://dev.azure.com/3Shape/Communicate/_apis/environments/kubernetes?api-version=6.0-preview

#https://dev.azure.com/3Shape/Communicate/_apis/distributedtask/environments/49/providers/kubernetes

# "area": "environments",
# "id": "d86b72de-d240-4d6f-8d06-08c2d66b015d",
# "maxVersion": 6.0,
# "minVersion": 5.2,
# "releasedVersion": "0.0",
# "resourceName": "environments",
# "resourceVersion": 1,
# "routeTemplate": "{project}/_apis/pipelines/{resource}/{environmentId}"

# "area": "distributedtask",
# "id": "8572b1fc-2482-47fa-8f74-7e3ed53ee54b",
# "maxVersion": 6.0,
# "minVersion": 5.0,
# "releasedVersion": "0.0",
# "resourceName": "environments",
# "resourceVersion": 1,
# "routeTemplate": "{project}/_apis/{area}/{resource}/{environmentId}"

# "area": "environments",
# "id": "73fba52f-33ab-42b3-a538-ce67a9223b15",
# "maxVersion": 6.0,
# "minVersion": 5.2,
# "releasedVersion": "0.0",
# "resourceName": "kubernetes",
# "resourceVersion": 2,
# "routeTemplate": "{project}/_apis/pipelines/environments/{environmentId}/providers/{resource}/{resourceId}"

# "area": "distributedtask",
# "id": "73fba52f-15ab-42b3-a538-ce67a9223a04",
# "maxVersion": 6.0,
# "minVersion": 5.0,
# "releasedVersion": "0.0",
# "resourceName": "kubernetes",
# "resourceVersion": 1,
# "routeTemplate": "{project}/_apis/{area}/environments/{environmentId}/providers/{resource}/{resourceId}"