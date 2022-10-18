package helpers

import (
	s "strings"
	v "github.com/spf13/viper"
)

func ClusterName(resourceGroup string) string {
	return Format(v.GetString("ClusterNameConvention"), resourceGroup)
}

func InsightsName(resourceGroup string) string {
	return Format(v.GetString("InsightsNameConvention"), resourceGroup)
}

func RegistryName(resourceGroup string) string {
	middle := s.Split(resourceGroup, "-")[1]
	return Format(v.GetString("RegistryNameConvention"), middle)
}

func KeyVaultName(resourceGroup string) string {
	middle := s.Split(resourceGroup, "-")[1]
	return Format(v.GetString("KeyVaultNameConvention"), middle)
}

func GlobalResourceGroupName(resourceGroup string) string {
	middle := s.Split(resourceGroup, "-")[1]
	return Format(v.GetString("GlobalResourceGroupNameConvention"), middle)
}

func PublicIpName(prefix string, cluster string) string {
	return PrependWithDash(prefix, Format(v.GetString("PublicIpNameConvention"), cluster))
}

func ServicePrincipalName(cluster string) string {
	return Format(v.GetString("ServicePrincipalNameConvention"), cluster)
}

func ServicePrincipalIdName(cluster string) string {
	return Format(v.GetString("ServicePrincipalIdNameConvention"), cluster)
}

func ServicePrincipalPasswordName(cluster string) string {
	return Format(v.GetString("ServicePrincipalPasswordNameConvention"), cluster)
}

func CertManagerDeploymentName() string {
	return v.GetString("CertManagerDeploymentNameConvention")
}

func NginxDeploymentName(prefix string) string {
	return PrependWithDash(prefix, v.GetString("NginxDeploymentNameConvention"))
}

func KedaDeploymentName() string {
	return v.GetString("KedaDeploymentNameConvention")
}

func KuredDeploymentName() string {
	return v.GetString("KuredDeploymentNameConvention")
}

func VpaDeploymentName() string {
	return v.GetString("VpaDeploymentNameConvention")
}

// LaterDo: Is there any way to determine this.
func DevOpsOrganizationName() string {
	return v.GetString("DevOpsOrganizationNameConvention")
}

// LaterDo: Is there any way to determine this.
func DevOpsProjectName() string {
	return v.GetString("DevOpsProjectNameConvention")
}

func DevOpsUnixName(name string) string {
	return s.Replace(s.Replace(s.ToLower(name), " - ", " ", -1), "\\W", "-", -1)
}

func DevOpsServiceAccountName(name string) string {
	unixName := DevOpsUnixName(name)
	return Format(v.GetString("DevOpsServiceAccountNameConvention"), unixName)
}

func DevOpsRoleBindingName(name string) string {
	unixName := DevOpsUnixName(name)
	return Format(v.GetString("DevOpsRoleBindingNameConvention"), unixName)
}
