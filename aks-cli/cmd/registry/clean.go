package registry

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var cleanCmd = &c.Command{
	Use:   "clean",
	Short: "Delete pre-release images that are older than 1 month",
	Long:  h.Description(`Delete pre-release images that are older than 1 month`),
	Run: func(cmd *c.Command, args []string) {
		registry := h.StringFlag(cmd, "registry")

		h.WriteInfo(h.Format("Delete pre-release images that are older than 1 month in registry '%s'", registry))

		if h.AreYouSure() {
			repositoriesString := h.AzQueryF(h.Format("acr repository list -n %s", registry), h.AzQueryFlags{Output: "tsv"})

			for _, repository := range h.Fields(repositoriesString) {
				tagsString := h.AzQueryF(h.Format("acr repository show-tags -n %s --repository %s", registry, repository), h.AzQueryFlags{Output: "tsv"})

				for _, tag := range h.Fields(tagsString) {
					currentMonthString := h.TimeNow().Format("200602")
					lastMonthString := h.TimeNow().AddDate(0, -1, 0).Format("200602")
					test1 := h.MatchString("\\d{8}\\.\\d+", tag)
					test2 := h.MatchString(currentMonthString+"\\d{2}\\.\\d+", tag)
					test3 := h.MatchString(lastMonthString+"\\d{2}\\.\\d+", tag)
					test4 := h.MatchString("v\\d+\\.\\d+\\.\\d+-1803", tag)

					if (test1 && !test2 && !test3) || (test4) {
						h.WriteInfo(h.Format("Deleting %s\\%s:%s", registry, repository, tag))
						h.AzCommand(h.Format("acr repository delete -n %s -t %s:%s -y", registry, repository, tag))
					}
				}
			}
		}
	},
}

func init() {
	cleanCmd.Flags().String("registry", "", "Azure Container Registry")
	cmd.RegistryCmd.AddCommand(cleanCmd)
}
