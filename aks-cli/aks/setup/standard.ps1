WriteAndSetUsage "aks setup standard"

CheckCurrentCluster

ExecuteCommand "aks kured install"
ExecuteCommand "aks nginx install -addIp"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"