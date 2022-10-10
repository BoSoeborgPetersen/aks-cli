package helpers

import (
	"fmt"
	"os"

	"github.com/fatih/color"
)

func IsDevelopmentMode() bool {
	return FileExists("/app/new-dev-aks-cli")
}

func SetDebuggingState(disable bool) {
	GlobalStateDebugging = !disable
}

func SetWhatIfState(disable bool) {
	GlobalStateWhatIf = !disable
}

func SetVerboseState(disable bool) {
	GlobalStateVerbose = !disable
}

func SetDefaultResourceGroup(resourceGroup string) {
	GlobalDefaultResourceGroup = resourceGroup
}

func DefaultResourceGroup() string {
	return GlobalDefaultResourceGroup
}

func WriteErrorMessage(message string) {
	color.Red(message)
}

type WriteFlags struct {
	Regex     string
	Index     int
	Namespace string
	Exit      bool
}

func HandleError[T any](result T, err error) T {
	WriteErrorIf(err)
	return result
}

func WriteErrorIf(err error) {
	if err != nil {
		color.Red(Format("Error: %s", err.Error()))
	}
}

func WriteError(message string) {
	WriteErrorF(message, WriteFlags{})
}

func WriteErrorF(message string, f WriteFlags) {
	regexString := ConditionalOperator(f.Regex, Format(" matching '%s'", f.Regex))
	indexString := ConditionalOperator(f.Index != 0, fmt.Sprintf(" with index '%d'", f.Index))
	namespaceString := ConditionalOperator(f.Namespace, Format(" in namespace '%s'", f.Namespace))

	// NOWDO: Add logging
	// log.Fatal(err)
	WriteErrorMessage(Format("%s%s%s%s", message, regexString, indexString, namespaceString))

	if f.Exit {
		os.Exit(1)
	}
}

func WriteInfoMessage(message string) {
	color.Cyan(message)
}

func Write(message string) {
	color.White(message)
}

func Format(format string, a ...any) string {
	return fmt.Sprintf(format, a...)
}

func ClearHost() {
	fmt.Print("\033c")
}

func WriteInfo(message string) {
	WriteInfoF(message, WriteFlags{})
}

func WriteInfoF(message string, f WriteFlags) {
	regexString := ConditionalOperator(f.Regex, Format(" matching '%s'", f.Regex))
	indexString := ConditionalOperator(f.Index != 0, fmt.Sprintf(" with index '%d'", f.Index))
	namespaceString := ConditionalOperator(f.Namespace, Format(" in namespace '%s'", f.Namespace))

	WriteInfoMessage(Format("%s%s%s%s", message, regexString, indexString, namespaceString))

	if f.Exit {
		os.Exit(0)
	}
}

func UpdateShellWindowTitle() {
	windowTitle := CurrentClusterName() + ConditionalOperator(IsDevelopmentMode(), " (dev)")
	fmt.Print("\033]0;" + windowTitle + "\007")
}

func WriteVerbose(message string) {
	if Verbose {
		color.Yellow(message)
	}
}

func WriteDebug(message string) {
	if Debug {
		// TODO: Get color right
		color.Green(message)
	}
}

func Exit(code int) {
	os.Exit(code)
}
