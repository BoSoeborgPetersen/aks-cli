WriteAndSetUsage "aks setup windows"

VerifyCurrentCluster

ExecuteCommand "aks monitoring install"
ExecuteCommand "aks analytics install"