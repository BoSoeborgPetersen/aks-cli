package lastApplied

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var importCmd = &c.Command{
	Use:   "import",
	Short: "Import Last-Applied-Config from file",
	Long:  h.Description(`Import Last-Applied-Config from file`),
	Run: func(cmd *c.Command, args []string) {
		regex := h.StringFlag("regex")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		h.WriteInfoF("Loading Last-Applied-Config", h.WriteFlags{Regex: regex, Namespace: namespace})

		// TODO: Put in helper
		files := h.ReadDir(h.GetConfigString("KubectlLastAppliedPath"))

		h.WriteVerbose(h.Format("Files: %s", h.JoinF(files, ",")))

		for _, file := range files {
			h.WriteInfo(h.Format("Applying Last-Applied-Config from file '%s'", file))

			h.KubectlCommand(h.Format("apply -f %s", file))
		}
	},
}

func init() {
	importCmd.Flags().String("regex", "", "Expression to match against name")
	importCmd.Flags().String("namespace", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	importCmd.Flags().Bool("all-namespaces", false, h.GetConfigString(h.KubernetesAllNamespacesDescription))
	cmd.LastAppliedCmd.AddCommand(importCmd)
}
