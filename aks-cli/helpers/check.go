package helpers

import (
	"fmt"
	r "regexp"
)

// LaterDo: Text could be reused
// Check(check, Format("Subscription '%s' does not exist", name)) // The text "<var_name> '"+name+"' does not exist" is used often
func Check[T string | int | bool](check T, errorMessage string) {
	if !testCondition(check) {
		// TODO: Print Cobra usage string
		// WriteUsage()
		WriteErrorF(errorMessage, WriteFlags{Exit: true})
	}
}

func CheckNot[T string | int | bool](check T, errorMessage string) {
	if testCondition(check) {
		// TODO: Print Cobra usage string
		// WriteUsage()
		WriteErrorF(errorMessage, WriteFlags{Exit: true})
	}
}

func CheckVariable[T string | int | bool](variable T, variableName string) {
	Check(variable, Format("The following argument is required: <%s>", variableName))
}

func CheckSemanticVersion(version string) bool {
	return HandleError(r.MatchString("^[\\d]+(\\.[\\d]+)?(\\.[\\d]+)?$", version))
}

func CheckVersion(version string, defaulttt string) string {
	version = SetDefaultIfEmpty(version, defaulttt)
	check := CheckSemanticVersion(version)
	Check(check, Format("The specified version '%s' is not a valid Semantic Version (i.e. 'x.y.z')", version))
	return version
}

func CheckOptionalNumberRange(number int, variableName string, min int, max int) {
	if number != 0 {
		rangeCheck := number >= min && number <= max
		Check(rangeCheck, fmt.Sprintf("Invalid variable <%s>, value '%d' outside range (%d - %d)", variableName, number, min, max))
	}
}

func CheckNumberRange(number int, variableName string, min int, max int) { //, defaulttt int) {
	// if defaulttt != -1 {
	// 	number = SetDefaultIfEmpty(number, string(defaulttt))
	// }

	CheckVariable(number, variableName)
	CheckOptionalNumberRange(number, variableName, min, max)
}
