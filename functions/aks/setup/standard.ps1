# TODO: Refactor.
WriteAndSetUsage "aks setup standard"

VerifyCurrentCluster

ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks nginx install"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks analytics install"