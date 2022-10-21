package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var appVersion = "2.0.0"

var rootCmd = &c.Command{
	Use:     "aks",
	Version: appVersion,
	Short:   "aks",
	Long: h.Logo() +
		h.If(h.IsDevelopmentMode(), "\n --- DEVELOPMENT EDITION --- \n\n") +
		"Welcome to the AKS (Azure Kubernetes Service) CLI (aks)!\n\n" +
		"Get list of tools present with 'aks tools'",
	Example: "aks version",
	PersistentPreRun: func(cmd *c.Command, args []string) {
		h.GlobalCurrentCmd = cmd
		h.GlobalCurrentArgs = args
	},
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		h.WriteError(err.Error())
		h.Exit(1)
	}
	h.SaveConfig()
}

func init() {
	rootCmd.PersistentFlags().BoolVarP(&h.Verbose, "verbose", "v", false, "Verbose output")
	rootCmd.PersistentFlags().BoolVar(&h.Debug, "debug", false, "Debug output")
	rootCmd.PersistentFlags().BoolVar(&h.WhatIf, "whatif", false, "Dry run")

	h.LoadConfig()
}
