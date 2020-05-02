param($environmentName, $namespace, $serviceEndpointId, $clusterName)

WriteAndSetUsage "aks devops environment add-kubernetes <environment name> <namespace> <service endpoint id> <cluster name>"

CheckCurrentCluster
$cluster = GetCurrentClusterName
SetDefaultIfEmpty ([ref]$clusterName) $cluster

if (!$serviceEndpointId){
    Write-Host ("Creating DevOps Service-Connection '$environmentName-$namespace, Namespace: $namespace'")
    aks devops service-connection create "$environmentName-$namespace" $namespace
    Write-Verbose "QUERY: az devops service-endpoint list --query `"[?name==$environmentName-$namespace].id`" -o tsv"
    while (!$serviceEndpointId){
        $serviceEndpointId = az devops service-endpoint list --query "[?name==$environmentName-$namespace].id" -o tsv
    }
}

CheckVariable $environmentName "environment name"
CheckVariable $namespace "namespace"
CheckVariable $serviceEndpointId "service endpoint id"
CheckVariable $clusterName "cluster name"

$teamName = GetDevOpsTeamName

$arguments=@{
    "name" = "$namespace"
    "namespace" = "$namespace"
    "clusterName" = "$clusterName"
    "serviceEndpointId" = "$serviceEndpointId"
}
$json = $arguments | ConvertTo-Json
Write-Verbose $json
$json | Out-File -FilePath ~/azure-devops-environment-add-kubernetes.json
$environmentId = az devops invoke --area environments --resource environments --route-parameters project=$teamName --http-method GET --api-version 6.0-preview --query "value[?name==$environmentName].id" -o tsv
az devops invoke --area environments --resource kubernetes --route-parameters project=$teamName environmentId=$environmentId --http-method POST --api-version 6.0-preview --in-file ~/azure-devops-environment-add-kubernetes.json
Remove-Item ~/azure-devops-environment-add-kubernetes.json