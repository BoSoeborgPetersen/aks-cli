# TODO: Test
param($resourceGroup, $location, $globalSubscription, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku, $masterDataIp, $metaDataIp, $dmeIp, [switch] $useServicePrincipal)

WriteAndSetUsage ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<location>" = AzureLocationDescription
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
    "[minNodeCount]" = "Autoscaler Minimum Node Count (default: 3)"
    "[maxNodeCount]" = "Autoscaler Maximum Node Count (default: 20)"
    "[nodeSize]" = "Azure VM Node Size (default: 'Standard_D2s_v3')"
    "[loadBalancerSku]" = "Azure Load Balancer SKU (basic, standard)"
    "[-useServicePrincipal]" = "Use Service Principal instead of Managed Identity"
})

# WantToContinue "Create Azure Resource Group '$resourceGroup', in location '$location'"
# AksCommand resource-group create $resourceGroup $location

WantToContinue "Create AKS cluster, in resource group '$resourceGroup'"
AksCommand create standard $resourceGroup $minNodeCount $maxNodeCount $nodeSize $loadBalancerSku 

WantToContinue "Authorize AKS cluster Managed Identity to access global resources (cluster Resource Group & Azure Container Registry) in subscription '$globalSubscription'"
AksCommand identity authorize "'$globalSubscription'"

WantToContinue "Install Kured (KUbernetes REboot Daemon) (Helm chart)"
AksCommand kured install

WantToContinue "Install Nginx (Helm chart), using nginx config file with prefix 'communicate', with Azure public ip"
AksCommand nginx install -configPrefix communicate -addIp -skip

WantToContinue "Install Nginx (Helm chart) for deployment 'masterdata', using nginx config file with prefix 'communicate', with Azure public ip"
if ($masterDataIp){
    AksCommand nginx install -prefix masterdata -configPrefix communicate -oldDnsNamingConvention -ip $masterDataIp -skip
}
else {
    AksCommand nginx install -prefix masterdata -configPrefix communicate -oldDnsNamingConvention -addIp -skip
}

WantToContinue "Install Nginx (Helm chart) for deployment 'metadata', using nginx config file with prefix 'communicate', with Azure public ip"
if ($metaDataIp){
    AksCommand nginx install -prefix metadata -configPrefix communicate -oldDnsNamingConvention -ip $metaDataIp -skip
}
else {
    AksCommand nginx install -prefix metadata -configPrefix communicate -oldDnsNamingConvention -addIp -skip
}

# WantToContinue "Install Nginx (Helm chart) for deployment 'dme', using nginx config file with prefix 'communicate', with Azure public ip"
# if ($dmeIp){
#     AksCommand nginx install -prefix dme -configPrefix communicate -oldDnsNamingConvention -ip $dmeIp -skip
# }
# else {
#     AksCommand nginx install -prefix dme -configPrefix communicate -oldDnsNamingConvention -addIp -skip
# }

# WantToContinue "Install Nginx (Helm chart) for deployment 'modelservice', using nginx config file with prefix 'communicate', with Azure public ip"
# AksCommand nginx install -prefix modelservice -configPrefix communicate -addIp -skip

# WantToContinue "Install Nginx (Helm chart) for deployment 'backup', using nginx config file with prefix 'communicate', with Azure public ip"
# AksCommand nginx install -prefix backup -configPrefix communicate -oldDnsNamingConvention -addIp -skip

WantToContinue "Install Certificate Manager (Helm chart)"
AksCommand cert-manager install

WantToContinue "Install Keda (Helm chart)"
AksCommand keda install

WantToContinue "Create Azure Operational Insights Workspace and attach it to the AKS cluster"
AksCommand insights install