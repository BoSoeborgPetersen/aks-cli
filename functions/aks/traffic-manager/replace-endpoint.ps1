# TODO: Not working.
# TODO: Refactor.
param($new, $old)

WriteAndSetUsage "aks traffic-manager replace-endpoint <new>"

CheckVariable $new "new endpoint name"
SetDefaultIfEmpty ([ref]$old) "AKS"

ExecuteCommand "az network traffic-manager endpoint create -g $AzureServiceResourceGroupName --profile-name $AzureTrafficManagerName -n $old --type azureEndpoints --target-resource-id $AzureReservedIpName --endpoint-status enabled $debugString"
ExecuteCommand "az network traffic-manager endpoint update -g $AzureServiceResourceGroupName --profile-name $AzureTrafficManagerName -n $new --endpoint-status Disabled $debugString"