package helm

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var importCmd = &c.Command{
	Use:   "import",
	Short: "Import Helm release from file",
	Long:  h.Description(`Import Helm release from file`),
	Run: func(cmd *c.Command, args []string) {
		regex := h.StringFlag("regex")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		h.WriteInfoF("Loading Helm releases", h.WriteFlags{Regex: regex, Namespace: namespace})

		files := h.ReadDir(h.GetConfigString("KubectlHelmSecretPath"))

		h.WriteVerbose(h.Format("Files: %s", h.Join(files)))

		for _, file := range files {
			h.WriteInfo(h.Format("Applying Helm release from file '%s'", file))

			name := h.ReplaceAllString(file, h.GetConfigString("KubectlHelmSecretPath")+"/sh\\.helm\\.release\\.v1\\.([\\w-]+)\\.v\\d+\\.json", "$1")
			version := h.ReplaceAllString(file, h.GetConfigString("KubectlHelmSecretPath")+"/sh\\.helm\\.release\\.v1\\.[\\w-]+\\.v(\\d+)\\.json", "$1")
			h.WriteVerbose(h.Format("Name: %s", name))
			h.WriteVerbose(h.Format("Version: %s", version))
			h.KubectlCommand(h.Format("create -f %s", file))
			h.HelmCommand(h.Format("rollback %s %s", name, version))
			// h.HelmCommandP("rollback", h.HelmFlags{ Name: name, Version: version })
		}
	},
}

func init() {
	importCmd.Flags().StringP("regex", "r", "", "Expression to match against name")
	importCmd.Flags().StringP("namespace", "n", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	importCmd.Flags().BoolP("all-namespaces", "A", false, h.GetConfigString(h.KubernetesAllNamespacesDescription))
	cmd.HelmCmd.AddCommand(importCmd)
}
