package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var getCmd = &c.Command{
	Use:   "get <type>",
	Short: "Get Kubernetes resources",
	Long:  h.Description(`Get Kubernetes resources`),
	Args:  h.ValidKubectlResourceType("Kubernetess resource <type>", true),
	Run: func(cmd *c.Command, args []string) {
		resourceType := h.StringArg(0)
		regex := h.StringFlag("regex")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		h.WriteInfoF(h.Format("Get '%s'", resourceType), h.WriteFlags{Regex: regex, Namespace: namespace})

		h.KubectlCommandF(h.Format("get %s", resourceType), h.KubectlFlags{Regex: regex, Namespace: namespace})
	},
}

func init() {
	getCmd.Flags().StringP("regex", "r", "", "Expression to match against name")
	getCmd.MarkFlagRequired("regex")
	getCmd.Flags().StringP("namespace", "n", "default", h.GetConfigString(h.KubernetesNamespaceDescription))
	getCmd.Flags().BoolP("all-namespaces", "A", false, h.GetConfigString(h.KubernetesAllNamespacesDescription))
	rootCmd.AddCommand(getCmd)
}
