$usage = Write-Usage "aks setup communicate"

VerifyCurrentCluster $usage

ExecuteCommand "aks nginx install `"masterdata`""
ExecuteCommand "aks nginx install `"dme`""
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks analytics install"