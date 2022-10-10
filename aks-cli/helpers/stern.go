package helpers

func SternCommand(regex string, namespace string) {
	// labelString := ConditionalOperator(label, " -l app="+label)
	namespaceString := ConditionalOperator(namespace == "all", " --all-namespaces")
	namespaceString = ConditionalOperator(namespace, " -n "+namespace)

	ExecuteCommand("stern " + regex + /*labelString +*/ namespaceString)
}
