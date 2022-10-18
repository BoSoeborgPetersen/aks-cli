package lastApplied

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var removeCmd = &c.Command{
	Use:   "remove",
	Short: "Remove workload",
	Long:  h.Description(`Remove workload`),
	Run: func(cmd *c.Command, args []string) {
		regex := h.StringFlag("regex")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		h.WriteInfoF("Removing workload", h.WriteFlags{Regex: regex, Namespace: namespace})

		resourceTypes := []string{"service", "deployment", "horizontalpodautoscaler", "issuer", "ingress"}

		// NOWDO: Try out
		// h.WriteInfo(h.Format("Types: %s", h.JoinF(resourceTypes, ",")))
		h.WriteInfo(h.Format("Types: %v", resourceTypes))

		for _, resourceType := range resourceTypes {
			h.WriteInfoF(h.Format("Getting names of type '%s'", resourceType), h.WriteFlags{Regex: regex, Namespace: namespace})

			names := h.KubectlQueryF(h.Format("get %s", resourceType), h.KubectlFlags{JsonPath: "{$.items[?(@.metadata.name!='kubernetes')].metadata.name}", Regex: regex, Namespace: namespace, Output: "json"})

			h.WriteInfo(h.Format("Names: %s", names))

			if h.AreYouSure() {
				for _, name := range h.Fields(names) {
					h.KubectlCommand(h.Format("delete %s %s", resourceType, name))
				}
			}
		}
	},
}

func init() {
	removeCmd.Flags().String("regex", "", "Expression to match against name")
	removeCmd.Flags().String("namespace", "", h.KubernetesNamespaceDescription())
	removeCmd.Flags().Bool("all-namespaces", false, h.KubernetesAllNamespacesDescription())
	cmd.LastAppliedCmd.AddCommand(removeCmd)
}
