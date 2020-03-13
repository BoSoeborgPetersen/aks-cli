# TODO: Refactor.
param([string]$newEndpoint)

ExecuteCommand ("az network traffic-manager endpoint create -g $AzureServiceResourceGroupName --profile-name $AzureTrafficManagerName -n 'AKS' --type azureEndpoints --target-resource-id $AzureReservedIpName --endpoint-status enabled $debugString")
ExecuteCommand ("az network traffic-manager endpoint update -g $AzureServiceResourceGroupName --profile-name $AzureTrafficManagerName -n $newEndpoint --endpoint-status Disabled $debugString")