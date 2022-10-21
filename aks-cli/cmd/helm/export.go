package helm

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var exportCmd = &c.Command{
	Use:   "export",
	Short: "Export Helm release to file",
	Long:  h.Description(`Export Helm release to file`),
	Run: func(cmd *c.Command, args []string) {
		regex := h.StringFlag("regex")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		h.WriteInfoF("Saving Helm releases", h.WriteFlags{Regex: regex, Namespace: namespace})
		names := h.HelmQueryP(h.Format("list -q -r %s", regex), h.HelmFlags{Namespace: namespace})
		h.WriteVerbose(h.Format("Names: %s", names))

		for _, name := range h.Fields(names) {
			h.WriteVerbose(h.Format("Name: %s", name))
			// version := h.HelmQuery(h.Format("status %s -o json | jq .version", name))
			json := h.HelmQuery(h.Format("status %s -o json", name))
			version := h.JqQuery(json, ".version")[0]
			h.KubectlSaveHelmSecret(name, version, namespace)
		}
	},
}

func init() {
	exportCmd.Flags().StringP("regex", "r", "", "Expression to match against name")
	exportCmd.Flags().StringP("namespace", "n", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	exportCmd.Flags().BoolP("all-namespaces", "A", false, h.GetConfigString(h.KubernetesAllNamespacesDescription))

	cmd.HelmCmd.AddCommand(exportCmd)
}
