WriteAndSetUsage "aks tiller install"

CheckCurrentCluster

Write-Info "Installing Tiller (Helm server-side)"

KubectlCommand "create serviceaccount tiller" -n kube-system
KubectlCommand "create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller"
Helm2Command "init --service-account tiller --node-selectors `"beta.kubernetes.io/os=linux`""