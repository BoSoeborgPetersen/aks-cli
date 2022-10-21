package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradesCmd = &c.Command{
	Use:   "upgrades",
	Short: "Show Nginx (Helm chart) upgradable versions",
	Long:  h.Description(`Show Nginx (Helm chart) upgradable versions`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Show Nginx upgradable versions")

		h.HelmSearchRepo("ingress-nginx/ingress-nginx")
	},
}

func init() {
	cmd.NginxCmd.AddCommand(upgradesCmd)
}
