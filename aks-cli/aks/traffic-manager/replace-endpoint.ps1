# TODO: REWRITE!!!
param($new, $old)

WriteAndSetUsage "aks traffic-manager replace-endpoint <new>"

CheckVariable $new "new endpoint name"
SetDefaultIfEmpty ([ref]$old) "AKS"

AzCommand "network traffic-manager endpoint create -g $AzureServiceResourceGroupName --profile-name $AzureTrafficManagerName -n $old --type azureEndpoints --target-resource-id $AzureReservedIpName --endpoint-status enabled"
AzCommand "network traffic-manager endpoint update -g $AzureServiceResourceGroupName --profile-name $AzureTrafficManagerName -n $new --endpoint-status Disabled"