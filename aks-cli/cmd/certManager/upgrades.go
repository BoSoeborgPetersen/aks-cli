package certManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradesCmd = &c.Command{
	Use:   "upgrades",
	Short: "Show Certificate Manager upgradable versions",
	Long:  h.Description(`Show Certificate Manager upgradable versions`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Show Certificate Manager upgradable versions")

		h.HelmSearchRepoW("jetstack/cert-manager")
	},
}

func init() {
	cmd.CertManagerCmd.AddCommand(upgradesCmd)
}
