package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace",
	Short: "Uninstall & install Nginx (Helm chart)",
	Long:  h.Description(`Uninstall & install Nginx (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		h.WriteInfo("Replacing Nginx")

		if h.AreYouSure() {
			uninstallCmd.Run(cmd, []string{"-y"})
			installCmd.Run(cmd, []string{})
		}
	},
}

func init() {
	cmd.NginxCmd.AddCommand(replaceCmd)
}
