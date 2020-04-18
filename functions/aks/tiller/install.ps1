$usage = Write-Usage "aks tiller install"

VerifyCurrentCluster $usage

Write-Info ("Installing Tiller (Helm server-side)")

ExecuteCommand ("kubectl create serviceaccount tiller -n kube-system $kubeDebugString")
ExecuteCommand ("kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller $kubeDebugString")
ExecuteCommand ("helm init --service-account=tiller $debugString")
# TODO: Cleanup string
ExecuteCommand ("kubectl patch deploy tiller-deploy -n kube-system -p '{\`"apiVersion\`":\`"apps/v1\`",\`"spec\`":{\`"template\`":{\`"spec\`":{\`"serviceAccount\`":\`"tiller\`",\`"nodeSelector\`":{\`"beta.kubernetes.io/os\`":\`"linux\`"}}}}}' $kubeDebugString")