$usage = Write-Usage "aks monitoring install"

VerifyCurrentCluster $usage

Write-Info ("Installing Prometheus")

ExecuteCommand "helm install --namespace monitoring -n prometheus stable/prometheus -f config\helm-prometheus.yaml $debugString"

Write-Info ("Installing Grafana")

ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\DataSource.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\K8s Cluster Summary.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\Windows Node 2.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\Windows Node w_ process info.yaml' $kubeDebugString"
ExecuteCommand "kubectl apply -n monitoring -f 'config\configmaps\Windows Node.yaml' $kubeDebugString"

ExecuteCommand "helm install --namespace monitoring -n grafana stable/grafana -f config\helm-grafana.yaml $debugString"