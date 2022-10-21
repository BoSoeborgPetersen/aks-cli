package serviceConnection

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace <name>",
	Short: "Replace Azure DevOps Service-Connection",
	Long:  h.Description(`Replace Azure DevOps Service-Connection`),
	Args:  h.RequiredArg("Service Connection <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringArg(0)
		namespace := h.StringFlag("namespace")

		h.WriteInfo("Replacing (delete, then create) Service Connection")

		DeleteCmd.Run(cmd, []string{name, namespace})
		CreateCmd.Run(cmd, []string{name, namespace})
	},
}

func init() {
	replaceCmd.Flags().StringP("namespace", "n", "default", "Kubernetes namespace")
	devops.ServiceConnectionCmd.AddCommand(replaceCmd)
}
