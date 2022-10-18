package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var logsCmd = &c.Command{
	Use:   "logs <regex>",
	Short: "Get container logs",
	Long:  h.Description(`Get container logs`),
	Args:  h.RequiredArg("expression (<regex>) to match against name"),
	Run: func(cmd *c.Command, args []string) {
		regex := args[0]
		index := h.IntFlag("index")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		if index != -1 {
			namespace, name := h.KubectlGetRegex("pod", regex, index, namespace)

			h.WriteInfoF(h.Format("Show pod '%s' logs", name), h.WriteFlags{Regex: regex, Index: index, Namespace: namespace})

			h.KubectlCommandF(h.Format("logs %s", name), h.KubectlFlags{Namespace: namespace})
		} else {
			h.WriteInfoF("Show pod logs with Stern", h.WriteFlags{Regex: regex, Namespace: namespace})

			h.SternCommand(regex, h.SternFlags{Namespace: namespace})
		}
	},
}

func init() {
	logsCmd.Flags().IntP("index", "i", -1, "Index of the pod to open shell in")
	logsCmd.Flags().StringP("namespace", "n", "default", h.KubernetesNamespaceDescription())
	logsCmd.Flags().BoolP("all-namespaces", "A", false, h.KubernetesAllNamespacesDescription())
	rootCmd.AddCommand(logsCmd)
}
