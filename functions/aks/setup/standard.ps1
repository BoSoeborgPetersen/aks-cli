# TODO: Change to script.
# TODO: Refactor.
WriteAndSetUsage "aks setup standard"

CheckCurrentCluster

ExecuteCommand "aks tiller install"
ExecuteCommand "aks tiller wait"
ExecuteCommand "aks nginx install"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"