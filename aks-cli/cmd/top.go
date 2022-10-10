package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var topCmdValidTypes = map[string]string{
	"no|node|nodes": "Show Resource Utilization for Nodes",
	"po|pod|pods":   "Show Resource Utilization for Pods",
}

var topCmd = &c.Command{
	Use:   "top <type> <regex>",
	Short: "Show Kubernetes resource utilization",
	Long:  h.Description(`Show Kubernetes resource utilization`),
	Args: h.RequiredAll(
		h.ValidArg("Kubernetess resource <type>", topCmdValidTypes, false),
		h.RequiredArgAt("expression (<regex>) to match against name", 1),
	),
	Run: func(cmd *c.Command, args []string) {
		resourceType := args[0]
		regex := args[1]

		h.CheckCurrentCluster()
		match := h.MatchString("po|pod|pods", resourceType)
		namespace := h.NamespaceFlagAllCheckIf(cmd, match)

		h.WriteInfoF(h.Format("Show resource utilization of '%s'", resourceType), h.WriteFlags{Regex: regex, Namespace: namespace})

		h.KubectlCommandF(h.Format("top %s", resourceType), h.KubectlFlags{Regex: regex, Namespace: namespace})
	},
}

func init() {
	topCmd.Flags().StringP("namespace", "n", "", h.KubernetesNamespaceDescription())
	topCmd.Flags().BoolP("all-namespaces", "A", false, h.KubernetesAllNamespacesDescription())
	rootCmd.AddCommand(topCmd)
}
