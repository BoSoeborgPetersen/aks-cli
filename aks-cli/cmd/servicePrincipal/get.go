package servicePrincipal

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var getCmd = &c.Command{
	Use:   "get",
	Short: "Get AKS cluster Service Principal ID",
	Long:  h.Description(`Get AKS cluster Service Principal ID`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Get current AKS cluster service principal")

		h.AzAksCurrentCommandF("show", h.AzAksCommandFlags{ Query: "servicePrincipalProfile", Output: "tsv" })
	},
}

func init() {
	cmd.ServicePrincipalCmd.AddCommand(getCmd)
}
