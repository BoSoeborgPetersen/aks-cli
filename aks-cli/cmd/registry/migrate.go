package registry

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var migrateCmd = &c.Command{
	Use:   "migrate <source registry> <source registry repo> <destination registry repo>",
	Short: "Move images in repository in Azure Container Registry to another repository possible in another registry",
	Long:  h.Description(`Move images in repository in Azure Container Registry to another repository possible in another registry`),
	Args: h.RequiredAll(
		h.RequiredArg("source Azure registry"),
		h.RequiredArgAt("source Azure registry repository", 1),
		h.RequiredArgAt("destination Azure registry repository", 2),
	),
	Run: func(cmd *c.Command, args []string) {
		// LaterDo: Add a lot more checks.
		// LaterDo: Allow to run from other subscriptions (add subscription parameter, calculate other variables from that).
		oldRegistry := args[0]
		oldRegistryRepo := args[1]
		newRegistryRepo := args[2]
		newRegistry := h.StringFlag("destRegistry")

		if newRegistry == "" {
			newRegistry = oldRegistry
		}

		h.WriteInfo(h.Format("Migrate all docker images from registry/repo '%s/%s' to registry/repo '%s/%s'", oldRegistry, oldRegistryRepo, newRegistry, newRegistryRepo))

		imageTags := h.Fields(h.AzQuery(h.Format("acr repository show-tags -n %s --repository %s", oldRegistry, oldRegistryRepo)))

		for _, imageTag := range imageTags {
			h.WriteInfo(h.Format("Moving '%s.azurecr.io/%s:%s' to '%s.azurecr.io/%s:%s'", oldRegistry, oldRegistryRepo, imageTag, newRegistry, newRegistryRepo, imageTag))
			h.AzCommand(h.Format("acr import -n %s --source %s.azurecr.io/%s:%s --image %s:%s", newRegistry, oldRegistry, oldRegistryRepo, imageTag, newRegistryRepo, imageTag))
		}
	},
}

func init() {
	migrateCmd.Flags().String("destRegistry", "", "Destination Azure registry")
	cmd.RegistryCmd.AddCommand(migrateCmd)
}
