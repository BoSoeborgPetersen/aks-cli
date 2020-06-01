# LaterDo: Rewrite config files to new format.
WriteAndSetUsage "aks monitoring install"

CheckCurrentCluster

Write-Info "Installing Prometheus"

Helm3Command "install prometheus stable/prometheus -n monitoring -f $PSScriptRoot/config/helm-prometheus.yaml"

Write-Info "Installing Grafana"

KubectlCommand "apply -n monitoring -f 'config/configmaps/DataSource.yaml'"
KubectlCommand "apply -n monitoring -f 'config/configmaps/K8s Cluster Summary.yaml'"
KubectlCommand "apply -n monitoring -f 'config/configmaps/Windows Node 2.yaml'"
KubectlCommand "apply -n monitoring -f 'config/configmaps/Windows Node w_ process info.yaml'"
KubectlCommand "apply -n monitoring -f 'config/configmaps/Windows Node.yaml'"

Helm3Command "install grafana stable/grafana -n monitoring -f config/helm-grafana.yaml"