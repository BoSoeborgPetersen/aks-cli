# TODO: Rewrite
param($new, $old = "AKS")

WriteAndSetUsage ([ordered]@{
    "<new>" = "new endpoint name"
    "[old]" = "old endpoint name"
})

CheckVariable $new "new endpoint name"

AzCommand "network traffic-manager endpoint create -g $AzureServiceResourceGroup --profile-name $AzureTrafficManager -n $old --type azureEndpoints --target-resource-id $AzureReservedIp --endpoint-status enabled"
AzCommand "network traffic-manager endpoint update -g $AzureServiceResourceGroup --profile-name $AzureTrafficManager -n $new --endpoint-status Disabled"