package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

// NOWDO: Fix
// shellCommands := map[string]string{
// 	"ash":        "Ash (Alpine)",
// 	"bash":       "Bash (Debian)",
// 	"cmd":        "Command Prompt (Windows)",
// 	"powershell": "Powershell (Windows)",
// }

var shellCmd = &c.Command{
	Use:   "shell <regex>",
	Short: "Open shell inside container",
	Long:  h.Description(`Open shell inside container`),
	Args:  h.RequiredArg("expression (<regex>) to match against name"),
	Run: func(cmd *c.Command, args []string) {
		regex := args[0]
		shell := h.StringFlag(cmd, "shell")
		index := h.IntFlag(cmd, "index")

		// NOWDO: Fix
		// h.ShowSubMenu(shellCommands)
		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagAllCheck(cmd)

		namespace, name := h.KubectlGetRegex("pod", regex, index, namespace)

		if shell == "" {
			shell = testShell(shell, name, namespace, "bash")
			shell = testShell(shell, name, namespace, "ash")
			shell = testShell(shell, name, namespace, "powershell")
			shell = testShell(shell, name, namespace, "cmd")
		}

		h.WriteInfoF(h.Format("Open shell '%s' inside pod '%s'", shell, name), h.WriteFlags{Regex: regex, Index: index, Namespace: namespace})

		shell = testShell(shell, name, namespace, shell)

		if shell == "" {
			h.WriteError("Could not open shell inside pod")
			h.Exit(1)
		}

		h.KubectlCommandF(h.Format("exec -it %s", name), h.KubectlFlags{Namespace: namespace, PostFix: h.Format(" -- %s", shell)})
	},
}

func testShell(shell string, name string, namespace string, tryShell string) string {
	if shell == "" {
		output := h.KubectlCommandF(h.Format("exec %s", name), h.KubectlFlags{Namespace: namespace, PostFix: h.Format(" -- %s 2>&1", tryShell)})
		if output == "" || h.Contains(output, "Microsoft Corporation") {
			shell = tryShell
		}
	}
	return shell
}

func init() {
	shellCmd.Flags().StringP("shell", "s", "", "Shell type (ash, bash, cmd, powershell)")
	shellCmd.Flags().IntP("index", "i", 0, "Index of the pod to open shell in")
	shellCmd.Flags().StringP("namespace", "n", "", h.KubernetesNamespaceDescription())
	shellCmd.Flags().BoolP("all-namespaces", "A", false, h.KubernetesAllNamespacesDescription())
	rootCmd.AddCommand(shellCmd)
}
