package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var editCmd = &c.Command{
	Use:   "edit <type> <regex>",
	Short: "Edit Kubernetes resource",
	Long:  h.Description(`Edit Kubernetes resource`),
	Args: h.RequiredAll(
		h.ValidKubectlResourceType("Kubernetess resource <type>", false),
		h.RequiredArgAt("expression (<regex>) to match against name", 1),
	),
	Run: func(cmd *c.Command, args []string) {
		resourceType := h.StringArg(0)
		regex := h.StringArg(1)
		index := h.IntFlag("index")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		namespace, name := h.KubectlGetRegex(resourceType, regex, index, namespace)

		h.WriteInfoF(h.Format("Edit resource '%s' of type '%s'", name, resourceType), h.WriteFlags{Regex: regex, Index: index, Namespace: namespace})

		h.KubectlCommandF(h.Format("edit %s %s", resourceType, name), h.KubectlFlags{Namespace: namespace})
	},
}

func init() {
	editCmd.Flags().IntP("index", "i", 0, "Index of the pod to open shell in")
	editCmd.Flags().StringP("namespace", "n", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	editCmd.Flags().BoolP("all-namespaces", "A", false, h.GetConfigString(h.KubernetesAllNamespacesDescription))

	rootCmd.AddCommand(editCmd)
}
