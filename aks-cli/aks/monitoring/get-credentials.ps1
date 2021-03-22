WriteAndSetUsage

CheckCurrentCluster

KubectlQuery "get secret --namespace monitoring grafana -o jsonpath='{.data.admin-password}' | base64 -d"