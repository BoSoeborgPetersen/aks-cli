package helpers

func StringFlag(name string) string {
	f, err := GlobalCurrentCmd.Flags().GetString(name)
	return IfElse(err != nil, "", f)
}

func StringFlagPrependWithDash(prefixName string, name string) string {
	configPrefix := StringFlag(prefixName)
	return PrependWithDash(configPrefix, name)
}

func IntFlagRange(name string, min int, max int) int {
	i := IntFlag(name)
	CheckNumberRange(i, name, min, max)
	return i
}

func IntFlag(name string) int {
	f, err := GlobalCurrentCmd.Flags().GetInt(name)
	return IfElse(err != nil, 0, f)
}

func BoolFlag(name string) bool {
	f, err := GlobalCurrentCmd.Flags().GetBool(name)
	return IfElse(err != nil, false, f)
}

func NginxDeploymentNamePrefixFlag() string {
	return PrependWithDash(StringFlag("prefix"), GetConfigString(NginxDeploymentName))
}

func IntArgRange(index int, name string, min int, max int) int {
	count := Atoi(GlobalCurrentArgs[index])
	CheckNumberRange(count, name, min, max)
	return count
}

func StringArg(index int) string {
	if len(GlobalCurrentArgs) > index {
		return GlobalCurrentArgs[index]
	}
	return ""
}

func SubscriptionArgCheck(index int) string {
	globalSubscription := GlobalCurrentArgs[index]
	AzCheckSubscription(globalSubscription)
	return globalSubscription
}

func DeploymentFlagCheck(namespace string) string {
	deployment := StringFlag("deployment")
	return KubectlCheckDeployment(deployment, namespace)
}

func NamespaceArgCheck(index int) string {
	namespace := GlobalCurrentArgs[index]
	KubectlCheckNamespace(namespace)
	return namespace
}

func NamespaceFlagAll() string {
	namespace := StringFlag("namespace")
	allNamespaces := BoolFlag("all-namespaces")
	return IfElse(allNamespaces, "all", namespace)
}

func NamespaceFlagCheck() string {
	namespace := StringFlag("namespace")
	KubectlCheckNamespace(namespace)
	return namespace
}

func NamespaceFlagAllCheck() string {
	namespace := NamespaceFlagAll()
	KubectlCheckNamespace(namespace)
	return namespace
}

func NamespaceFlagAllCheckIf(match bool) string {
	namespace := NamespaceFlagAll()
	namespace = If(match, namespace)
	KubectlCheckNamespace(namespace)
	return namespace
}

func VersionFlag(latestVersion string) string {
	version := StringFlag("version")
	version = CheckVersion(version, latestVersion)
	return version
}
