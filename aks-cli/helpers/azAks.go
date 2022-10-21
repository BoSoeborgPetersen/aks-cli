package helpers

type AzAksFlags struct {
	Location string
	Version  string
	Query    string
	Output   string
}

func (f AzAksFlags) LocationString() string {
	return IfF(f.Location, " -l %s")
}

func (f AzAksFlags) VersionString() string {
	return IfF(f.Version, " -k %s")
}

func AzAksCommand(command string) string {
	return AzAksCommandP(command, AzAksFlags{})
}

func AzAksCommandP(command string, f AzAksFlags) string {
	return AzCommandP(Format("aks %s%s%s", command, f.LocationString(), f.VersionString()), AzFlags{Query: f.Query, Output: f.Output})
}

func AzAksCurrentCommand(command string) string {
	return AzAksCurrentCommandP(command, AzAksFlags{})
}

func AzAksCurrentCommandP(command string, f AzAksFlags) string {
	return AzAksCommandP(Format("%s -g %s -n %s", command, GetGlobalCurrentCluster().ResourceGroup, GetGlobalCurrentCluster().Name), f)
}

func AzAksQuery(command string) string {
	return AzAksQueryP(command, AzAksFlags{})
}

func AzAksQueryP(command string, f AzAksFlags) string {
	return AzQueryP(Format("aks %s%s%s", command, f.LocationString(), f.VersionString()), AzFlags{Query: f.Query, Output: f.Output})
}

func AzAksCurrentQuery(command string) string {
	return AzAksCurrentQueryP(command, AzAksFlags{})
}

func AzAksCurrentQueryP(command string, f AzAksFlags) string {
	return AzAksQueryP(Format("%s -g %s -n %s", command, GetGlobalCurrentCluster().ResourceGroup, GetGlobalCurrentCluster().Name), f)
}
