package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var switchCmd = &c.Command{
	Use:   "switch",
	Short: "Switch Azure subscription / AKS cluster",
	Long:  h.Description(`Switch Azure subscription / AKS cluster`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		// LaterDO: Add message reading something like "ACCESS DENIED !!!", when unauthorized.
		cluster := h.BoolFlag("cluster")
		resourceGroup := h.StringFlag("resourceGroup")
		clean := h.BoolFlag("clean")
		clear := h.BoolFlag("clear")

		if clean {
			h.WriteInfo("Clearing AKS cluster credentials")
			h.KubectlClearConfig(resourceGroup)
		}

		if !h.IsSet(resourceGroup) {
			if !cluster {
				h.SwitchCurrentSubscription(true)
			}

			h.SwitchCurrentCluster(true, clear)
		} else {
			h.WriteInfo(h.Format("Switching AKS cluster '%s'", resourceGroup))
			h.SwitchCurrentClusterTo(resourceGroup)
		}
	},
}

func init() {
	switchCmd.Flags().BoolP("cluster", "n", false, "Only switch AKS cluster, not Azure subscription")
	switchCmd.Flags().StringP("resourceGroup", "g", "", "Switch to this AKS cluster, instead of using menu")
	switchCmd.Flags().Bool("clean", false, "Clear and replace AKS cluster credentials")
	switchCmd.Flags().Bool("clear", false, "Clear cluster list")
	rootCmd.AddCommand(switchCmd)
}
