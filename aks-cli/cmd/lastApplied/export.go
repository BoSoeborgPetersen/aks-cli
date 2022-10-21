package lastApplied

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var exportCmd = &c.Command{
	Use:   "export",
	Short: "Export Last-Applied-Config to file",
	Long:  h.Description(`Export Last-Applied-Config to file`),
	Run: func(cmd *c.Command, args []string) {
		regex := h.StringFlag("regex")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		h.WriteInfoF("Saving Last-Applied-Config", h.WriteFlags{Regex: regex, Namespace: namespace})

		resourceTypes := []string{"Service", "Deployment", "HorizontalPodAutoscaler", "Issuer", "Ingress", "CronJob", "ScaledObject"}

		h.WriteVerbose(h.Format("Types: %s", h.JoinF(resourceTypes, ",")))

		for _, resourceType := range resourceTypes {
			h.WriteInfoF(h.Format("Getting names of type '%s'", resourceType), h.WriteFlags{Regex: regex, Namespace: namespace})

			nameString := h.KubectlQueryF(h.Format("get %s", resourceType), h.KubectlFlags{JsonPath: "{$.items[?(@.metadata.name!='kubernetes')].metadata.name}", Regex: regex, Namespace: namespace, Output: "json"})
			names := h.Fields(nameString)

			h.WriteVerbose(h.Format("Names: %s", h.JoinF(names, ",")))

			for _, name := range names {
				h.KubectlSaveLastApplied(resourceType, name, namespace)
			}
		}

		h.KubectlSaveLastApplied("Secret", "keda-metric-connectionstring-secret", "default")
	},
}

func init() {
	exportCmd.Flags().String("regex", "", "Expression to match against name")
	exportCmd.Flags().String("namespace", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	exportCmd.Flags().String("all-namespaces", "", h.GetConfigString(h.KubernetesAllNamespacesDescription))
	cmd.LastAppliedCmd.AddCommand(exportCmd)
}
