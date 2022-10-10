package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var switchCmd = &c.Command{
	Use:   "switch",
	Short: "Switch Azure subscription / AKS cluster",
	Long: h.Description(`Switch Azure subscription / AKS cluster`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		// TODO: Add message reading something like "ACCESS DENIED !!!", when unauthorized.
		cluster := h.BoolFlag(cmd, "cluster")
		resourceGroup := h.StringFlag(cmd, "resourceGroup")
		clean := h.BoolFlag(cmd, "clean")

		if clean {
			h.WriteInfo("Clearing AKS cluster credentials")
			h.KubectlClearConfig(resourceGroup)
		}

		if resourceGroup == "" {
			if !cluster {
				h.SwitchCurrentSubscription(true)
			}

			h.SwitchCurrentCluster(true, false)
		} else {
			h.WriteInfo(h.Format("Switching AKS cluster '%s'", resourceGroup))
			h.SwitchCurrentClusterTo(resourceGroup)
		}
	},
}

func init() {
	switchCmd.Flags().BoolP("cluster", "c", false, "Only switch AKS cluster, not Azure subscription")
	switchCmd.Flags().StringP("resourceGroup", "r", "", "Switch to this AKS cluster, instead of using menu")
	switchCmd.Flags().Bool("clean", false, "Clear and replace AKS cluster credentials")
	rootCmd.AddCommand(switchCmd)
}
