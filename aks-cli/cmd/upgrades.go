package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradesCmd = &c.Command{
	Use:   "upgrades",
	Short: "Get AKS cluster upgradable versions",
	Long:  h.Description(`Get AKS cluster upgradable versions`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Current AKS cluster upgradable versions")

		// TODO: Rewrite
		h.Write(h.AzAksCurrentCommandP("get-upgrades", h.AzAksFlags{Query: "controlPlaneProfile.upgrades[].{Version:kubernetesVersion, IsPreview:isPreview}", Output: "table"}))
		// ($upgrades | ConvertFrom-Json | Sort-Object {[version] $_.kubernetesVersion} | Select-Object @{ name='Version';expression= { "$($_.kubernetesVersion) $($_.isPreview -replace 'True','(Preview)')" }} | Format-Table -HideTableHeaders | Out-String).Trim()
	},
}

func init() {
	rootCmd.AddCommand(upgradesCmd)
}
