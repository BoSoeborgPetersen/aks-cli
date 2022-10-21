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
		prefix := h.StringFlag("prefix")
		configPrefix := h.StringFlag("configPrefix")
		addIp := h.BoolFlag("addIp")
		sku := h.StringFlag("sku")
		ip := h.StringFlag("ip")
		oldDnsNamingConvention := h.BoolFlag("oldDnsNamingConvention")
		skip := h.BoolFlag("skip")
		upgrade := h.BoolFlag("upgrade")

		h.WriteDebug(h.Format("Prefix %s", prefix))
		h.WriteDebug(h.Format("Config Prefix: %s", configPrefix))

		namespace := "ingress"
		h.CheckCurrentCluster()
		resourceGroup := h.GetGlobalCurrentCluster().ResourceGroup

		groupName := ""
		groupName = h.ReplaceAll(groupName, "[0-9]+", "")
		dns := ""
		if oldDnsNamingConvention {
			dns = h.PrependWithDash(prefix, h.Format("%s-aks", groupName))
		} else {
			dns = h.PrependWithDash(prefix, groupName)
		}
		publicIp := h.PrependWithDash(prefix, h.GetConfigStringF(h.PublicIpName, resourceGroup))
		deployment := h.PrependWithDash(prefix, h.GetConfigString(h.NginxDeploymentName))
		configFile := h.PrependWithDash(configPrefix, "nginx-config.yaml")

		operationName := h.IfElse(upgrade, "Upgrading", "Installing")
		h.WriteInfo(h.Format("%s Nginx", operationName))

		if skip || h.AreYouSure() {
			if addIp {
				h.AzCommand(h.Format("network public-ip create -g %s -n %s --allocation-method Static --sku %s --idle-timeout 30", resourceGroup, publicIp, sku))
			}
			if !h.IsSet(ip) {
				ip = h.AzQueryP(h.Format("network public-ip show -g %s -n %s", resourceGroup, publicIp), h.AzFlags{Query: "[ipAddress]", Output: "tsv"})
			}
			h.KubectlCreateNamespace(namespace)

			var extraArgs []string
			if !h.IsSet(prefix) {
				s01 := h.Format("controller.electionID='%s-ingress-controller-leader'", prefix)
				s02 := h.Format("controller.ingressClass='%s'", prefix)
				s03 := h.Format("controller.ingressClassResource.name='%s'", prefix)
				s04 := h.Format("controller.ingressClassResource.controllerValue='k8s.io/%s'", deployment)
				s05 := "controller.ingressClassByName=true"
				s06 := h.Format("controller.extraArgs.default-ssl-certificate=default/%s-certificate", prefix)
				extraArgs = []string{s01, s02, s03, s04, s05, s06}
			}

			s1 := h.Format("controller.service.loadBalancerIP='%s'", ip)
			s2 := h.Format("controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group\"=%s", resourceGroup)
			s3 := h.Format("controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-dns-label-name\"=%s", dns)
			f := h.Format("/data/nginx/%s", configFile)
			args := []string{s1, s2, s3}
			args = append(args, extraArgs...)
			h.HelmCommandP(h.IfElse(upgrade, "upgrade", "install"), h.HelmFlags{Name: deployment, Repo: "ingress-nginx/ingress-nginx", Namespace: namespace, SetArgs: args, File: f})
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
