# TODO: Change to script.
WriteAndSetUsage "aks setup communicate"

CheckCurrentCluster

# TODO: Clean up deployment name.
ExecuteCommand "aks nginx install -deploymentName `"masterdata`"" -add-ip $true
# TODO: Clean up deployment name.
ExecuteCommand "aks nginx install -deploymentName `"dme`"" -add-ip $true
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"