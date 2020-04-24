# TODO: Change to script.
WriteAndSetUsage "aks setup windows"

CheckCurrentCluster

ExecuteCommand "aks monitoring install"
ExecuteCommand "aks insights install"