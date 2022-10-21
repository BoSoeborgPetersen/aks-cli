package helpers

import (
	c "github.com/spf13/cobra"
)

// Cobra global flags
var Verbose bool
var Debug bool
var WhatIf bool

func DebugString() string {
	return If(Debug, " --debug")
}

func KubeDebugString() string {
	return If(Debug, " --v=4")
}

// Cobra globals
var GlobalCurrentCmd *c.Command
var GlobalCurrentArgs []string

// Cobra helper functions
func RunFunctionConvert(f func()) func(cmd *c.Command, args []string) {
	return func(cmd *c.Command, args []string) {
		f()
	}
}
