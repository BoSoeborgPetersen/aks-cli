package kured

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var installCmd = &c.Command{
	Use:   "install",
	Short: "Install Kured (KUbernetes REboot Daemon) (Helm chart)",
	Long:  h.Description(`Install Kured (KUbernetes REboot Daemon) (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		skipNamespace := h.BoolFlag("skip-namespace")
		upgrade := h.BoolFlag("upgrade")

		h.CheckCurrentCluster()
		deployment := h.KuredDeploymentName()

		operationName := h.IfElse(upgrade, "Upgrading", "Installing")
		h.WriteInfo(h.Format("%s Kured (KUbernetes REboot Daemon)", operationName))

		if !skipNamespace {
			h.KubectlCommand(h.Format("create ns %s", deployment))
		}
		h.HelmCommandP(h.IfElse(upgrade, "upgrade", "install"), h.HelmFlags{Name: deployment, Repo: "kured/kured", Namespace: deployment, SetArgs: []string{"nodeSelector.\"kubernetes\\.io/os\"=linux"}})
	},
}

func init() {
	installCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace creation")
	installCmd.Flags().Bool("upgrade", false, "Skip verification")

	cmd.KuredCmd.AddCommand(installCmd)
}
