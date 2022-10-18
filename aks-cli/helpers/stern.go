package helpers

type SternFlags struct {
	Namespace string
	Label     string // Unused currently
}

func (f SternFlags) NamespaceString() string {
	return IfElse(f.Namespace == "all", " --all-namespaces", IfF(f.Namespace, " -n %s"))
}

func (f SternFlags) LabelString() string {
	return IfF(f.Label, " -l app=%s")
}

func SternCommand(regex string, f SternFlags) {
	ExecuteCommand(Format("stern %s%s%s", regex, f.LabelString(), f.NamespaceString()))
}
