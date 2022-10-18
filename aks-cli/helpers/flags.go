package helpers

func StringFlag(name string) string {
	// return HandleError(cmd.Flags().GetString(name))
	return HandleError(GlobalCurrentCmd.Flags().GetString(name))
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
	return HandleError(GlobalCurrentCmd.Flags().GetInt(name))
}

func BoolFlag(name string) bool {
	return HandleError(GlobalCurrentCmd.Flags().GetBool(name))
}

func NginxDeploymentNamePrefixFlag() string {
	prefix := StringFlag("prefix")
	return NginxDeploymentName(prefix)
}

func IntArgRange(args []string, index int, name string, min int, max int) int {
	count := Atoi(args[index])
	CheckNumberRange(count, name, min, max)
	return count
}

func SubscriptionArgCheck(args []string, index int) string {
	globalSubscription := args[index]
	AzCheckSubscription(globalSubscription)
	return globalSubscription
}

func DeploymentFlagCheck(namespace string) string {
	deployment := StringFlag("deployment")
	return KubectlCheckDeployment(deployment, namespace)
}

func NamespaceArgCheck(args []string, index int) string {
	namespace := args[index]
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
