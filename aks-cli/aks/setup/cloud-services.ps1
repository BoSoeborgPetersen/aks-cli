# TODO: Rewrite
WriteAndSetUsage "aks setup windows"

CheckCurrentCluster

ExecuteCommand "aks kured install"
ExecuteCommand "aks monitoring install"
ExecuteCommand "aks insights install"