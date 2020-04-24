WriteAndSetUsage "aks tiller install"

VerifyCurrentCluster

Write-Info "Installing Tiller (Helm server-side)"

ExecuteCommand "kubectl create serviceaccount tiller -n kube-system $kubeDebugString"
ExecuteCommand "kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller $kubeDebugString"
ExecuteCommand "helm init --service-account tiller --node-selectors `"beta.kubernetes.io/os`"=`"linux`" $debugString"