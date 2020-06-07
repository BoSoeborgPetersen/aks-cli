WriteAndSetUsage "aks setup identity"

CheckCurrentCluster

ExecuteCommand "aks kured install"
ExecuteCommand "aks nginx install -configPrefix identity -addIp"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"