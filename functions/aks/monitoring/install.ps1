WriteAndSetUsage "aks monitoring install"

VerifyCurrentCluster

ExecuteCommand "helm3 repo add stable https://kubernetes-charts.storage.googleapis.com $debugString"
ExecuteCommand "helm3 repo update $debugString"

Write-Info "Installing Prometheus"

ExecuteCommand "helm3 install prometheus stable/prometheus --namespace monitoring -f config\helm-prometheus.yaml $debugString"

Write-Info "Installing Grafana"

ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\DataSource.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\K8s Cluster Summary.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\Windows Node 2.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\Windows Node w_ process info.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\Windows Node.yaml' $kubeDebugString"

ExecuteCommand "helm3 install grafana stable/grafana --namespace monitoring -f config\helm-grafana.yaml $debugString"