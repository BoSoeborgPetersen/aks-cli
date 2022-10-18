package helpers

const ( // WiP
	HelmCommandInstall   = "Install"
	HelmCommandUninstall = "Uninstall"
	HelmCommandUpgrade   = "Upgrade"
)

type HelmFlags struct {
	Name      string
	Repo      string
	Namespace string
	Version   string
	SetArgs   []string
	File      string
}

func (f HelmFlags) RepoString() string {
	return IfF(f.Repo, " %s")
}

func (f HelmFlags) NamespaceString() string {
	return IfF(f.Namespace, " -n %s")
}

func (f HelmFlags) VersionString() string {
	return IfF(f.Version, " --version v%s")
}

func (f HelmFlags) FileString() string {
	return If(f.File, Format("%s%s", ExeLocation(), f.File))
}

func (f HelmFlags) SetArgsString() string {
	var s string
	for _, e := range f.SetArgs {
		s += Format(" --set %s", e)
	}
	return s
}

func HelmCommand(command string) {
	HelmCommandP(command, HelmFlags{})
}

func HelmCommandP(command string, f HelmFlags) {
	ExecuteCommand(Format("helm %s %s%s%s%s%s%s%s", command, f.Name, f.RepoString(), f.NamespaceString(), f.VersionString(), f.SetArgsString(), f.FileString(), DebugString()))
}

func HelmQuery(command string) string {
	return HelmQueryP(command, HelmFlags{})
}

func HelmQueryP(command string, f HelmFlags) string {
	return ExecuteQuery(Format("helm %s %s%s%s%s%s%s%s", command, f.Name, f.RepoString(), f.NamespaceString(), f.VersionString(), f.SetArgsString(), f.FileString(), DebugString()))
}

func HelmCheck(chart string, namespace string) {
	// NOWDO: Be quiet!!!
	// check := ExecuteQuery("helm status "+chart+namespaceString+" 2>null")
	check := HelmQueryP("status", HelmFlags{ Repo: chart, Namespace: namespace})

	if check == "" {
		WriteErrorF(Format("Chart '%s' does not exist", chart), WriteFlags{Namespace: namespace})
	}
}

// TODO: Split query string into commands
func HelmLatestChartVersion(chart string) string {
	return HelmQuery("search repo " + chart + " -o json | jq -r ' .[] | select(.name==\"" + chart + "\") | .version' | % TrimStart v")
	// return Jq()
}

func HelmAddRepo(name string, url string) {
	HelmCommand(Format("repo add %s %s", name, url))
	HelmCommand("repo update")
}
