package helpers

import (
	"os/exec"
	"strings"
)

func ExecuteCommand(command string) string {
	if !WhatIf {
		WriteVerbose(Format("COMMAND: %s", command))

		result := execCommandWithNative(command)

		WriteVerbose(Format("COMMAND - RESULT: \n%s", result))

		return result
	} else {
		WriteInfo(Format("WhatIf: %s", command))
	}
	return ""
}

func ExecuteQuery(query string) string {
	WriteVerbose(Format("QUERY: %s", query))

	result := execCommandWithNative(query)

	WriteVerbose(Format("QUERY - RESULT: \n%s", result))

	return result
}

func execCommandWithNative(command string) string {
	fields, _ := splitString(command)

	cli := exec.Command(fields[0], fields[1:]...)
	stdoutStderr, err := cli.CombinedOutput()

	result := strings.Trim(string(stdoutStderr), "\n")

	if err != nil {
		WriteError(result)
	}

	return result
}
