$usage = Write-Usage "aks setup communicate"

VerifyCurrentCluster $usage

# TODO: Clean up deployment name.
ExecuteCommand "aks nginx install -deploymentName `"masterdata`"" -add-ip $true
# TODO: Clean up deployment name.
ExecuteCommand "aks nginx install -deploymentName `"dme`"" -add-ip $true
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks analytics install"