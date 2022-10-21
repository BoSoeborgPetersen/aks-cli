package certManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace",
	Short: "Replace cert-manager",
	Long:  h.Description(`Uninstall & install Certificate Manager (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		h.WriteInfo("Replacing Cert-Manager")

		if h.AreYouSure() {
			UninstallFunc(false)
			InstallFunc(true, false)
		}
	},
}

func init() {
	cmd.CertManagerCmd.AddCommand(replaceCmd)
}
