# TODO: Refactor.
$usage = Write-Usage "aks setup standard"

VerifyCurrentCluster $usage

ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks nginx install"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks analytics install"