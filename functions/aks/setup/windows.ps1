$usage = Write-Usage "aks setup windows"

VerifyCurrentCluster $usage

# TODO: Rename to CloudServices
ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks monitoring install"
ExecuteCommand "aks analytics install"