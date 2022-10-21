package node

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var enableCmd = &c.Command{
	Use:   "enable",
	Short: "Enable node autoscaler",
	Long:  h.Description(`Enable node autoscaler`),
	Run: h.RunFunctionConvert(EnableFunc),
}

func EnableFunc() {
	min := h.IntFlagRange("min", 2, 100)
	max := h.IntFlagRange("max", 2, 100)

	h.CheckCurrentCluster()

	h.WriteInfo("Enabling node autoscaler")

	h.Write(h.AzAksCurrentCommand(h.Format("update --enable-cluster-autoscaler --min-count %d --max-count %d", min, max)))
}

func init() {
	enableCmd.Flags().Int("min", 2, h.GetConfigString(h.AzureVmMinNodeCountDescription))
	enableCmd.Flags().Int("max", 4, h.GetConfigString(h.AzureVmMaxNodeCountDescription))
	autoscaler.NodeCmd.AddCommand(enableCmd)
}
