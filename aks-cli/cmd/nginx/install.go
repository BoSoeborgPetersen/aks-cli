package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var installCmd = &c.Command{
	Use:   "install",
	Short: "Install Nginx (Helm chart)",
	Long:  h.Description(`Install Nginx (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		prefix := h.StringFlag(cmd, "prefix")
		configPrefix := h.StringFlag(cmd, "configPrefix")
		addIp := h.BoolFlag(cmd, "addIp")
		sku := h.StringFlag(cmd, "sku")
		ip := h.StringFlag(cmd, "ip")
		oldDnsNamingConvention := h.BoolFlag(cmd, "oldDnsNamingConvention")
		skip := h.BoolFlag(cmd, "skip")
		upgrade := h.BoolFlag(cmd, "upgrade")

		h.WriteDebug(h.Format("Prefix %s", prefix))
		h.WriteDebug(h.Format("Config Prefix: %s", configPrefix))

		namespace := "ingress"
		h.CheckCurrentCluster()
		resourceGroup := h.CurrentClusterResourceGroup()

		groupName := ""
		groupName = h.ReplaceAll(groupName, "[0-9]+", "")
		dns := ""
		if oldDnsNamingConvention {
			dns = h.PrependWithDash(prefix, h.Format("%s-aks", groupName))
		} else {
			dns = h.PrependWithDash(prefix, groupName)
		}
		publicIp := h.PublicIpName(prefix, resourceGroup)
		deployment := h.NginxDeploymentName(prefix)
		configFile := h.PrependWithDash(configPrefix, "nginx-config.yaml")

		operationName := h.ConditionalOperatorOr(upgrade, "Upgrading", "Installing")
		h.WriteInfo(h.Format("%s Nginx", operationName))

		if skip || h.AreYouSure() {
			if addIp {
				h.AzCommand(h.Format("network public-ip create -g %s -n %s --allocation-method Static --sku %s --idle-timeout 30", resourceGroup, publicIp, sku))
			}
			if ip == "" {
				ip = h.AzQueryF(h.Format("network public-ip show -g %s -n %s", resourceGroup, publicIp), h.AzQueryFlags{ Query: "[ipAddress]", Output: "tsv" })
			}
			h.KubectlCreateNamespace(namespace)

			extraParams := ""
			if prefix == "" {
				extraParams = h.Format("--set controller.electionID='%s-ingress-controller-leader' --set controller.ingressClass='%s' --set controller.ingressClassResource.name='%s' --set controller.ingressClassResource.controllerValue='k8s.io/%s' --set controller.ingressClassByName=true --set controller.extraArgs.default-ssl-certificate=default/%s-certificate", prefix, prefix, prefix, deployment, prefix)
			}

			// LaterDo: Replace ' with ", and " with '
			operation := h.ConditionalOperatorOr(upgrade, "upgrade", "install")
			h.HelmCommandF(h.Format("%s %s ingress-nginx/ingress-nginx --set controller.service.loadBalancerIP='%s' %s --set controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group\"=%s --set controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-dns-label-name\"=%s -f %s/data/nginx/%s", operation, deployment, ip, extraParams, resourceGroup, dns, h.ExeLocation(), configFile), namespace)
		}
	},
}

func init() {
	installCmd.Flags().String("prefix", "", "Kubernetes deployment name prefix")
	installCmd.Flags().String("configPrefix", "", "AKS-CLI config file name prefix")
	installCmd.Flags().Bool("addIp", false, "Flag to add Azure Public IP")
	installCmd.Flags().String("sku", "Basic", "Azure Public IP SKU")
	installCmd.Flags().String("ip", "", "Azure Public IP to use")
	installCmd.Flags().Bool("oldDnsNamingConvention", false, "Add '-aks' to dns name")
	installCmd.Flags().Bool("skip", false, "Skip AreYouSure")
	installCmd.Flags().Bool("upgrade", false, "Upgrade instead of installing")
	cmd.NginxCmd.AddCommand(installCmd)
}
