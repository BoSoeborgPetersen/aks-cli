package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradeCmd = &c.Command{
	Use:   "upgrade",
	Short: "Upgrade AKS cluster",
	Long:  h.Description(`Upgrade AKS cluster`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		version := h.StringFlag("version")
		preview := h.BoolFlag("preview")

		h.CheckCurrentCluster()

		if h.IsSet(version) {
			currentVersion := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "kubernetesVersion", Output: "tsv"})
			h.AzCheckUpgradableVersion(version, preview)
			h.WriteInfo(h.Format("Upgrading current cluster from '%s' to version '%s'", currentVersion, version))
		} else {
			previewString := h.If(!preview, "?!isPreview")
			version = h.AzAksCurrentQueryP("get-upgrades", h.AzAksFlags{Query: h.Format("controlPlaneProfile.upgrades[%s].kubernetesVersion | sort(@) | [-1]", previewString), Output: "tsv"})

			if h.IsSet(version) {
				currentVersion := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "kubernetesVersion", Output: "tsv"})

				previewString = h.If(preview, "(allow previews)")
				h.WriteInfo(h.Format("Upgrading current cluster from '%s' to version '%s', which is the newest upgradable version %s", currentVersion, version, previewString))
			} else {
				h.WriteInfoF("Cluster has the newest available version", h.WriteFlags{Exit: true})
			}
		}

		if h.AreYouSure() {
			h.AzAksCurrentCommandP("upgrade -y", h.AzAksFlags{Version: version})
		}
	},
}

func init() {
	upgradeCmd.Flags().String("version", "", "Version to upgrade to (default: newest stable upgradable version)")
	upgradeCmd.Flags().BoolP("preview", "p", false, "Allow upgrade to preview version")
	rootCmd.AddCommand(upgradeCmd)
}
