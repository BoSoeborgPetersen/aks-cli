package helpers

// type Az struct {
// 	Command      string
// 	Query        string
// 	Subscription string
// 	Output       string
// }

func (f AzFlags) QueryString() string {
	return IfF(f.Query, " --query \"%s\"")
}

func (f AzFlags) SubscriptionString() string {
	return IfF(f.Subscription, " --subscription '%s'")
}

// LaterDo: Try to avoid setting tsv all the time
func (f AzFlags) OutputString() string {
	return IfF(f.Output, " -o %s")
	// return IfElseF(az.Output, " -o %s", " -o tsv")
}

// func (az Az) Exec() string {
// 	return ExecuteCommand(Format("az %s%s%s%s", az.Command, az.QueryString(), az.OutputString(), DebugString()))
// }

// func (az Az) Pure() string {
// 	return ExecuteQuery(Format("az %s%s%s%s%s", az.Command, az.QueryString(), az.SubscriptionString(), az.OutputString(), DebugString()))
// }

type AzFlags struct {
	Query        string
	Subscription string
	Output       string
}

func AzCommand(command string) string {
	return AzCommandP(command, AzFlags{})
}

func AzCommandP(command string, f AzFlags) string {
	return ExecuteCommand(Format("az %s%s%s%s", command, f.QueryString(), f.OutputString(), DebugString()))
}

func AzQuery(command string) string {
	return AzQueryP(command, AzFlags{})
}

func AzQueryP(command string, f AzFlags) string {
	return ExecuteQuery(Format("az %s%s%s%s%s", command, f.QueryString(), f.SubscriptionString(), f.OutputString(), DebugString()))
}
