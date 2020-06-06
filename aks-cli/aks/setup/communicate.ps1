# LaterDo: Rewrite to script.
WriteAndSetUsage "aks setup communicate"

CheckCurrentCluster

ExecuteCommand "aks nginx install -deployment masterdata -addIp"
ExecuteCommand "aks nginx install -deployment dme -addIp"
ExecuteCommand "aks cert-manager install"
ExecuteCommand "aks insights install"