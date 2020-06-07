WriteAndSetUsage "aks setup communicate"

CheckCurrentCluster

ExecuteCommand "aks kured install"
ExecuteCommand "aks nginx install -deployment masterdata -configPrefix communicate -addIp"
ExecuteCommand "aks nginx install -deployment dme -configPrefix communicate -addIp"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"