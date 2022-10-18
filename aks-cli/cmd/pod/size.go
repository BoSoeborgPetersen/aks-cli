package pod

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var sizeCmd = &c.Command{
	Use:   "size <regex>",
	Short: "Get pod disk space usage",
	Long:  h.Description(`Get pod disk space usage`),
	Args:  h.RequiredArg("expression (<regex>) to match against name"),
	Run: func(cmd *c.Command, args []string) {
		regex := args[0]
		index := h.IntFlag("index")

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck()

		namespace, name := h.KubectlGetRegex("pod", regex, index, namespace)

		h.WriteInfoF(h.Format("Show pod '%s' content size", name), h.WriteFlags{Regex: regex, Namespace: namespace})

		command := ""
		command = testCommand(name, namespace, command, "du -h -s")
		command = testCommand(name, namespace, command, "powershell -c \"'{0} MB' -f ((Get-ChildItem C:\\app\\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)\"")

		h.KubectlCommandF(h.Format("exec %s", name), h.KubectlFlags{Namespace: namespace, PostFix: h.Format(" -- ", command)})
	},
}

func testCommand(name string, namespace string, command string, tryCommand string) string {
	if command == "" {
		output := h.KubectlQueryF(h.Format("exec %s", name), h.KubectlFlags{Namespace: namespace, PostFix: h.Format(" -- %s 2>&1", tryCommand)})
		if !h.Contains(output, "command terminated with exit code 126") {
			command = tryCommand
		}
	}
	return command
}

func init() {
	sizeCmd.Flags().IntP("index", "i", 0, "Index of the pod to open shell in")
	sizeCmd.Flags().StringP("namespace", "n", "", h.KubernetesNamespaceDescription())
	sizeCmd.Flags().BoolP("all-namespaces", "A", false, h.KubernetesAllNamespacesDescription())
	cmd.PodCmd.AddCommand(sizeCmd)
}
