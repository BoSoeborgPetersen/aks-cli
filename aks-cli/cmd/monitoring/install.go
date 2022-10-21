package monitoring

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

// NOWDO: Fix
var installCmd = &c.Command{
	Use:   "install",
	Short: "Install Monitoring with Prometheus and Grafana (Helm chart) (uses local config files)",
	Long:  h.Description(`Install Monitoring with Prometheus and Grafana (Helm chart) (uses local config files)`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		cluster := h.GetGlobalCurrentCluster().Name
		resourceGroup := h.GetGlobalCurrentCluster().ResourceGroup
		subscriptionId := h.GetGlobalCurrentSubscription().Id
		publicIp := h.GetConfigStringF(h.PublicIpName, cluster)
		publicIpId := h.Format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/publicIPAddresses/%s", subscriptionId, resourceGroup, publicIp)

		h.WriteInfo("Create monitoring namespace")
		h.KubectlCommand("create ns monitoring")

		h.WriteInfo("Installing Prometheus")

		h.HelmCommandP("upgrade --install", h.HelmFlags{ Name: "prometheus", Repo: "prometheus/prometheus", Namespace: "monitoring" })
		// Add Prometheus traffic manager with an endpoint for the cluster primary ip
		h.AzCommand(h.Format("network traffic-manager profile create -n %s-prometheus -g %s --routing-method Performance --unique-dns-name %s-prometheus", resourceGroup, resourceGroup, resourceGroup))
		h.AzCommand(h.Format("network traffic-manager endpoint create -n AKS -g %s --profile-name %s-prometheus --type azureEndpoints --target-resource-id %s", resourceGroup, resourceGroup, publicIpId))
		// Setup Ingress rules for Prometheus
		filepath := h.GuidFormat("~/%s.yaml")
		h.SaveFile(h.ReplaceAll(h.LoadFileRelative("/data/monitoring/Prometheus-Ingress.yaml"), "{{ClusterName}}", resourceGroup), filepath)
		h.KubectlCommand(h.Format("apply -n monitoring -f %s", filepath))
		h.DeleteTempFile(filepath)

		h.WriteInfo("Installing Grafana")

		// Add Prometheus data source on Grafana install
		path := h.ExeLocation()
		h.KubectlCommand(h.Format("apply -n monitoring -f '%s/data/monitoring/configmaps/DataSource.yaml'", path))
		h.KubectlCommand(h.Format("apply -n monitoring -f '%s/data/monitoring/configmaps/K8s Cluster Summary.yaml'", path))
		h.KubectlCommand(h.Format("apply -n monitoring -f '%s/data/monitoring/configmaps/NGINX Ingress Controller.yaml'", path))

		h.HelmCommandP("upgrade --install", h.HelmFlags{ Name: "grafana", Repo: "grafana/grafana", Namespace: "monitoring", SetArgs: []string{ "sidecar.datasources.enabled=true", "sidecar.dashboards.enabled=true", "persistence.enabled=true" } })

		// Add Grafana traffic manager with an endpoint for the cluster primary ip
		h.AzCommand(h.Format("network traffic-manager profile create -n %s-grafana -g %s --routing-method Performance --unique-dns-name %s-grafana", resourceGroup, resourceGroup, resourceGroup))
		h.AzCommand(h.Format("network traffic-manager endpoint create -n AKS -g %s --profile-name %s-grafana --type azureEndpoints --target-resource-id %s", resourceGroup, resourceGroup, publicIpId))
		// Setup Ingress rules for Grafana
		filepath = h.GuidFormat("~/%s.yaml")
		h.SaveFile(h.ReplaceAll(h.LoadFileRelative("/data/monitoring/Grafana-Ingress.yaml"), "{{ClusterName}}", resourceGroup), filepath)

		h.KubectlCommand(h.Format("apply -n monitoring -f %s", filepath))
		h.DeleteTempFile(filepath)
	},
}

func init() {
	cmd.MonitoringCmd.AddCommand(installCmd)
}
