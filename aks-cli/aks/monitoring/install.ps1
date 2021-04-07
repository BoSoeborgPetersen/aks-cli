WriteAndSetUsage

CheckCurrentCluster
$cluster = CurrentClusterName
$resourceGroup = CurrentClusterResourceGroup
$subscriptionId = CurrentSubscription
$publicIp = PublicIpName -cluster $cluster
$publicIpId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Network/publicIPAddresses/$publicIp"

Write-Info "Create monitoring namespace"
KubectlCommand "create ns monitoring"

Write-Info "Installing Prometheus"

HelmCommand "upgrade --install prometheus prometheus/prometheus" -n monitoring
# Add Prometheus traffic manager with an endpoint for the cluster primary ip
AzCommand "network traffic-manager profile create -n $resourceGroup-prometheus -g $resourceGroup --routing-method Performance --unique-dns-name $resourceGroup-prometheus"
AzCommand "network traffic-manager endpoint create -n AKS -g $resourceGroup --profile-name $resourceGroup-prometheus --type azureEndpoints --target-resource-id $publicIpId"
# Setup Ingress rules for Prometheus
$filepath = "~/$(New-Guid).yaml"
(Get-Content "$PSScriptRoot/config/Prometheus-Ingress.yaml") -replace '\${{ClusterName}}',"$resourceGroup" | Out-File $filepath
KubectlCommand "apply -n monitoring -f $filepath"
Remove-Item $filepath

Write-Info "Installing Grafana"

# Add Prometheus data source on Grafana install
KubectlCommand "apply -n monitoring -f '$PSScriptRoot/config/configmaps/DataSource.yaml'"
KubectlCommand "apply -n monitoring -f '$PSScriptRoot/config/configmaps/K8s Cluster Summary.yaml'"
KubectlCommand "apply -n monitoring -f '$PSScriptRoot/config/configmaps/NGINX Ingress Controller.yaml'"

HelmCommand "upgrade --install grafana grafana/grafana --set sidecar.datasources.enabled=true --set sidecar.dashboards.enabled=true --set persistence.enabled=true" -n monitoring

# Add Grafana traffic manager with an endpoint for the cluster primary ip
AzCommand "network traffic-manager profile create -n $resourceGroup-grafana -g $resourceGroup --routing-method Performance --unique-dns-name $resourceGroup-grafana"
AzCommand "network traffic-manager endpoint create -n AKS -g $resourceGroup --profile-name $resourceGroup-grafana --type azureEndpoints --target-resource-id $publicIpId"
# Setup Ingress rules for Grafana
$filepath = "~/$(New-Guid).yaml"
(Get-Content "$PSScriptRoot/config/Grafana-Ingress.yaml") -replace '\${{ClusterName}}',"$resourceGroup" | Out-File $filepath
KubectlCommand "apply -n monitoring -f $filepath"
Remove-Item $filepath