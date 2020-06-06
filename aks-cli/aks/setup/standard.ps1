# LaterDo: Rewrite to script.
WriteAndSetUsage "aks setup standard"

CheckCurrentCluster

ExecuteCommand "aks kured install"
ExecuteCommand "aks nginx install"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"