package pod

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var cleanCmd = &c.Command{
	Use:   "clean",
	Short: "Get rid of all failed pods in all namespaces",
	Long:  h.Description(`Get rid of all failed pods in all namespaces`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		
		h.WriteInfo("Deleting all failed pods in all namespaces")
		
		if h.AreYouSure() {
			h.KubectlCommand("delete pod -A --field-selector 'status.phase=Failed'")
		}
	},
}

func init() {
	cmd.PodCmd.AddCommand(cleanCmd)
}
