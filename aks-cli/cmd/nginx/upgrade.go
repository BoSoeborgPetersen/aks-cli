package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

// NOWDO: Fix
var upgradeCmd = &c.Command{
	Use:   "upgrade",
	Short: "Upgrade Nginx (Helm chart)",
	Long:  h.Description(`Upgrade Nginx (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		// prefix, _ := cmd.Flags().GetString("prefix")
		// configPrefix, _ := cmd.Flags().GetString("configPrefix")
		// ip, _ := cmd.Flags().GetString("ip")
		// oldDnsNamingConvention, _ := cmd.Flags().GetBool("oldDnsNamingConvention")
		// skip, _ := cmd.Flags().GetBool("skip")

		// if IsSet(ip) {
		// 	svc := "nginx-ingress-ingress-nginx-controller"
		// 	svc = h.ConditionalOperatorOr(prefix, prefix+"-"+svc, svc)
		// 	ip = h.KubectlQueryF("get svc "+svc, h.KubectlFlags{Namespace: "ingress", JsonPath: "'{.spec.loadBalancerIP}'"})
		// }

		// prefixString := h.ConditionalOperator(prefix, "-prefix '"+prefix+"'")
		// configPrefixString := h.ConditionalOperator(configPrefix, "-configPrefix '"+configPrefix+"'")
		// ipString := h.ConditionalOperator(ip, "-ip '"+ip+"'")
		// oldDnsNamingConventionString := h.ConditionalOperator(oldDnsNamingConvention, "-oldDnsNamingConvention")
		// skipString := h.ConditionalOperator(skip, "-skip")

		// h.AksCommand("nginx install " + prefixString + " " + configPrefixString + " " + ipString + " " + oldDnsNamingConventionString + " " + skipString + " -upgrade")
		installCmd.Run(cmd, []string{"--upgrade"})
	},
}

func init() {
	upgradeCmd.Flags().String("prefix", "", "Kubernetes deployment name prefix")
	upgradeCmd.Flags().String("configPrefix", "", "AKS-CLI config file name prefix")
	upgradeCmd.Flags().String("ip", "", "Azure Public IP to use")
	upgradeCmd.Flags().String("oldDnsNamingConvention", "", "Add '-aks' to dns name")
	upgradeCmd.Flags().String("skip", "", "Skip AreYouSure")
	cmd.NginxCmd.AddCommand(upgradeCmd)
}
