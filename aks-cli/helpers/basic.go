package helpers

import (
	"os/exec"
	"strings"
)

// TODO: Change to string array.
func ExecuteCommand(command string) string {
	if !WhatIf {
		command = ReplaceAll(command, `\`, `/`)
		WriteVerbose(Format("COMMAND: %s", command))

		result := execCommandWithNative(command)

		WriteVerbose(Format("COMMAND - RESULT: \n%s", TakeS(result, 1000)))

		return result
	} else {
		WriteInfo(Format("WhatIf: %s", command))
	}
	return ""
}

func ExecuteQuery(query string) string {
	WriteVerbose(Format("QUERY: %s", query))

	result := execCommandWithNative(query)

	WriteVerbose(Format("QUERY - RESULT: \n%s", TakeS(result, 1000)))

	return result
}

func execCommandWithNative(command string) string {
	fields, _ := splitString(command)

	cli := exec.Command(fields[0], fields[1:]...)
	stdoutStderr, err := cli.CombinedOutput()

	result := strings.Trim(string(stdoutStderr), "\n\r")

	if err != nil {
		WriteError(result)
	}

	return result
}
