package helpers

import (
	c "github.com/spf13/cobra"
)

func StringFlag(cmd *c.Command, name string) string {
	return HandleError(cmd.Flags().GetString(name))
}

func StringFlagPrependWithDash(cmd *c.Command, prefixName string, name string) string {
	configPrefix := StringFlag(cmd, prefixName)
	return PrependWithDash(configPrefix, name)
}

func IntFlagRange(cmd *c.Command, name string, min int, max int) int {
	i := IntFlag(cmd, name)
	CheckNumberRange(i, name, min, max)
	return i
}

func IntFlag(cmd *c.Command, name string) int {
	return HandleError(cmd.Flags().GetInt(name))
}

func BoolFlag(cmd *c.Command, name string) bool {
	return HandleError(cmd.Flags().GetBool(name))
}

func NginxDeploymentNamePrefixFlag(cmd *c.Command) string {
	prefix := StringFlag(cmd, "prefix")
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

func DeploymentFlag(cmd *c.Command, namespace string) string {
	deployment := StringFlag(cmd, "deployment")
	return KubectlCheckDeployment(deployment, namespace)
}

func NamespaceArgCheck(args []string, index int) string {
	namespace := args[index]
	KubectlCheckNamespace(namespace)
	return namespace
}

func NamespaceFlagAll(cmd *c.Command) string {
	namespace := StringFlag(cmd, "namespace")
	allNamespaces := BoolFlag(cmd, "all-namespaces")
	return ConditionalOperatorOr(allNamespaces, "all", namespace)
}

func NamespaceFlagCheck(cmd *c.Command) string {
	namespace := StringFlag(cmd, "namespace")
	KubectlCheckNamespace(namespace)
	return namespace
}

func NamespaceFlagAllCheck(cmd *c.Command) string {
	namespace := NamespaceFlagAll(cmd)
	KubectlCheckNamespace(namespace)
	return namespace
}

func NamespaceFlagAllCheckIf(cmd *c.Command, match bool) string {
	namespace := NamespaceFlagAll(cmd)
	namespace = ConditionalOperator(match, namespace)
	KubectlCheckNamespace(namespace)
	return namespace
}

func VersionFlag(cmd *c.Command, latestVersion string) string {
	version := StringFlag(cmd, "version")
	version = CheckVersion(version, latestVersion)
	return version
}
