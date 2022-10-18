package autoscaler

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var PodCmd = &c.Command{
	Use:   "pod",
	Short: "Setup VPA (Vertical Pod Autoscaling)",
	Long:  h.Description(`Setup automatic Kubernetes deployment scaling (Pod scaling)`),
}

func init() {
	cmd.AutoscalerCmd.AddCommand(PodCmd)
}
