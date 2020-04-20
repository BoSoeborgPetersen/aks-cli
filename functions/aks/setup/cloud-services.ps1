$usage = Write-Usage "aks setup windows"

VerifyCurrentCluster $usage

ExecuteCommand "aks monitoring install"
ExecuteCommand "aks analytics install"