package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var manifestCmd = &c.Command{
	Use:   "manifest",
	Short: "Edit nginx-config.yaml file, with Kubernetes Config Map",
	Long:  h.Description(`Edit nginx-config.yaml file, with Kubernetes Config Map`),
	Run: func(cmd *c.Command, args []string) {
		configFile := h.StringFlagPrependWithDash("configPrefix", "nginx-config.yaml")

		h.CheckCurrentCluster()

		h.WriteInfo("Edit manifest config file (yaml) used for installing Nginx")

		// NOWDO: Test
		h.ExecuteCommand(h.Format("nano %s/data/nginx/%s", h.ExeLocation(), configFile))
	},
}

func init() {
	manifestCmd.Flags().String("configPrefix", "", "AKS-CLI config file name prefix")
	cmd.NginxCmd.AddCommand(manifestCmd)
}
