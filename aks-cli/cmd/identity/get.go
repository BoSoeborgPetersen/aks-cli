package identity

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var getCmd = &c.Command{
	Use:   "get",
	Short: "Get AKS cluster Managed Identity ID",
	Long:  h.Description(`Get AKS cluster Managed Identity ID`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Get current AKS cluster managed identity (system assigned)")
		h.AzAksCurrentCommandF("show", h.AzAksCommandFlags{ Query: "identity.principalId", Output: "tsv" })

		h.WriteInfo("Get current AKS cluster managed identity (user assigned)")
		h.AzAksCurrentCommandF("show", h.AzAksCommandFlags{ Query: "identityProfile.kubeletidentity.clientId", Output: "tsv" })
	},
}

func init() {
	cmd.IdentityCmd.AddCommand(getCmd)
}
