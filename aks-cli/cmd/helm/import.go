package helm

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
	v "github.com/spf13/viper"
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

		files := h.ReadDir(v.GetString("KubectlHelmSecretPath"))

		h.WriteVerbose(h.Format("Files: %s", h.Join(files)))

		for _, file := range files {
			h.WriteInfo(h.Format("Applying Helm release from file '%s'", file))

			name := h.ReplaceAllString(file, v.GetString("KubectlHelmSecretPath")+"/sh\\.helm\\.release\\.v1\\.([\\w-]+)\\.v\\d+\\.json", "$1")
			version := h.ReplaceAllString(file, v.GetString("KubectlHelmSecretPath")+"/sh\\.helm\\.release\\.v1\\.[\\w-]+\\.v(\\d+)\\.json", "$1")
			h.WriteVerbose(h.Format("Name: %s", name))
			h.WriteVerbose(h.Format("Version: %s", version))
			h.KubectlCommand(h.Format("create -f %s", file))
			h.HelmCommand(h.Format("rollback %s %s", name, version))
		}
	},
}

func init() {
	importCmd.Flags().StringP("regex", "r", "", "Expression to match against name")
	importCmd.Flags().StringP("namespace", "n", "", h.KubernetesNamespaceDescription())
	importCmd.Flags().BoolP("all-namespaces", "A", false, h.KubernetesAllNamespacesDescription())
	cmd.HelmCmd.AddCommand(importCmd)
}
