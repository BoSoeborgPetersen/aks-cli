package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var versionsCmd = &c.Command{
	Use:   "versions",
	Short: "Get AKS versions",
	Long:  h.Description(`Get AKS versions`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		location := h.StringFlag("location")

		h.CheckCurrentClusterOrVariable(location, "[location]")

		if h.IsSet(location) {
			h.AzCheckLocation(location)
			h.WriteInfo("Available AKS versions for location '" + location + "'")
		} else {
			location = h.CurrentClusterLocation()
			h.WriteInfo("Available AKS versions for cluster location '" + location + "'")
		}

		// NOWDO: Improve
		h.Write(h.AzAksCommandP("get-versions", h.AzAksFlags{Location: location, Query: "orchestrators[].{Version:orchestratorVersion, IsPreview:isPreview}", Output: "table"}))
		// versions := h.AzAksCommandF("get-versions", h.AzAksCommandFlags{Location: location, Query: "orchestrators", Output: `json | jq -r 'sort_by(.orchestratorVersion) | map(.orchestratorVersion+(.isPreview // \"\") | sub(\"True\";\" (Preview)\"))'`})
		// sort_by(.orchestratorVersion) | map(.orchestratorVersion+(.isPreview // "") | sub("True";" (Preview)"))
	},
}

func init() {
	versionsCmd.Flags().StringP("location", "l", "", h.AzureLocationDescription("Current AKS cluster location"))
	rootCmd.AddCommand(versionsCmd)
}
