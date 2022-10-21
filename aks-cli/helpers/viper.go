package helpers

import (
	v "github.com/spf13/viper"
)

const (
	GlobalSubscriptions               = "GlobalSubscriptions"
	GlobalCurrentSubscription         = "GlobalCurrentSubscription"
	GlobalSubscriptionUsedForClusters = "GlobalSubscriptionUsedForClusters"
	GlobalClusters                    = "GlobalClusters"
	GlobalCurrentCluster              = "GlobalCurrentCluster"
	// ---------------------
	CertManagerNamespaceConst = "cert-manager-namespace"
	CertManagerUrl = "CertManagerUrl"
	// ---------------------
	AzureLocationDescription             = "AzureLocationDescription"
	AzureVmMinNodeCountDescription       = "AzureVmMinNodeCountDescription"
	AzureVmMaxNodeCountDescription       = "AzureVmMaxNodeCountDescription"
	KubernetesDeploymentDescription      = "KubernetesDeploymentDescription"
	KubernetesMinPodCountDescription     = "KubernetesMinPodCountDescription"
	KubernetesMaxPodCountDescription     = "KubernetesMaxPodCountDescription"
	KubernetesCpuScalingLimitDescription = "KubernetesCpuScalingLimitDescription"
	KubernetesNamespaceDescription       = "KubernetesNamespaceDescription"
	KubernetesAllNamespacesDescription   = "KubernetesAllNamespacesDescription"
	// AksVersionDescription   = "AksVersionDescription"
	ClusterName                  = "ClusterNameConvention"
	InsightsName                 = "InsightsNameConvention"
	RegistryName                 = "RegistryNameConvention"
	KeyVaultName                 = "GlobalResourceGroupNameConvention"
	GlobalResourceGroupName      = "InsightsNameConvention"
	ServicePrincipalName         = "ServicePrincipalNameConvention"
	ServicePrincipalIdName       = "ServicePrincipalIdNameConvention"
	ServicePrincipalPasswordName = "ServicePrincipalPasswordNameConvention"
	CertManagerDeploymentName    = "CertManagerDeploymentNameConvention"
	KedaDeploymentName           = "KedaDeploymentNameConvention"
	KuredDeploymentName          = "KuredDeploymentNameConvention"
	VpaDeploymentName            = "VpaDeploymentNameConvention"
	PublicIpName                 = "PublicIpNameConvention"
	NginxDeploymentName          = "NginxDeploymentNameConvention"
	// LaterDo: Is there any way to determine this.
	DevOpsOrganizationName = "DevOpsOrganizationNameConvention"
	// LaterDo: Is there any way to determine this.
	DevOpsProjectName          = "DevOpsProjectNameConvention"
	DevOpsServiceAccountName   = "DevOpsServiceAccountNameConvention"
	DevOpsRoleBindingName      = "DevOpsRoleBindingNameConvention"
	GlobalDebuggingState       = "GlobalDebuggingState"
	GlobalWhatIfState          = "GlobalWhatIfState"
	GlobalVerboseState         = "GlobalVerboseState"
	GlobalDefaultResourceGroup = "GlobalDefaultResourceGroup"
)

type Subscription struct {
	Id       string
	Name     string
	TenantId string
}

type Cluster struct {
	ResourceGroup     string
	NodeResourceGroup string
	Name              string
	Location          string
	Fqdn              string
}

func GetEnv[T any](name string, t T) T {
	v.UnmarshalKey(name, &t)
	return t
}

func SetEnv(name string, value any) {
	v.Set(name, value)
}

func GetGlobalCurrentSubscription() Subscription {
	return GetEnv(GlobalCurrentSubscription, Subscription{})
}

func GetGlobalCurrentCluster() Cluster {
	return GetEnv(GlobalCurrentCluster, Cluster{})
}

func GetConfigBool(name string) bool {
	return v.GetBool(name)
}

func SetConfigBool(name string, value bool) {
	v.Set(name, value)
}

func GetConfigString(name string) string {
	return v.GetString(name)
}

func SetConfigString(name string, value string) {
	v.Set(name, value)
}

func GetConfigStringF(name string, p1 string) string {
	return Format(v.GetString(name), p1)
}

func GetConfigStringP(name string, def string) string {
	return Format("%s%s", v.GetString(name), IfF(def, " (default: %s)"))
}

func SaveConfig() {
	v.WriteConfig()
}

func LoadConfig() {
	v.SetConfigFile("aks-cli.yaml")
	v.ReadInConfig()
}
