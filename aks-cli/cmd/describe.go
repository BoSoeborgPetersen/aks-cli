package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var describeCmd = &c.Command{
	Use:   "describe <type> <regex>",
	Short: "Describe Kubernetes resources",
	Long:  h.Description(`Describe Kubernetes resources`),
	Args: h.RequiredAll(
		h.ValidKubectlResourceType("Kubernetess resource <type>", false),
		h.RequiredArgAt("expression (<regex>) to match against name", 1),
	),
	Run: func(cmd *c.Command, args []string) {
		resourceType := args[0]
		regex := args[1]
		index := h.IntFlag(cmd, "index")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck(cmd)

		namespace, name := h.KubectlGetRegex(resourceType, regex, index, namespace)

		h.WriteInfoF(h.Format("Describe resource '%s' of type '%s'", name, resourceType), h.WriteFlags{Regex: regex, Index: index, Namespace: namespace})

		h.KubectlCommandF(h.Format("describe %s %s", resourceType, name), h.KubectlFlags{Namespace: namespace})
	},
}

func init() {
	describeCmd.Flags().IntP("index", "i", 0, "Index of the pod to open shell in")
	describeCmd.Flags().StringP("namespace", "n", "", h.KubernetesNamespaceDescription())
	describeCmd.Flags().BoolP("all-namespaces", "A", false, h.KubernetesAllNamespacesDescription())
	rootCmd.AddCommand(describeCmd)
}
