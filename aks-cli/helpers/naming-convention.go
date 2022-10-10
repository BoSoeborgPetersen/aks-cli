package helpers

import (
	s "strings"
)

func ClusterName(resourceGroup string) string {
	return Format("%s-aks", resourceGroup)
}

func InsightsName(resourceGroup string) string {
	return Format("%s-aks-insights", resourceGroup)
}

func RegistryName(resourceGroup string) string {
	middle := s.Split(resourceGroup, "-")[1]
	return Format("gl-%s-acr", middle)
}

func KeyVaultName(resourceGroup string) string {
	middle := s.Split(resourceGroup, "-")[1]
	return Format("gl-%s-aks-vault", middle)
}

func GlobalResourceGroupName(resourceGroup string) string {
	middle := s.Split(resourceGroup, "-")[1]
	return Format("gl-%s" , middle)
}

func PublicIpName(prefix string, cluster string) string {
	return PrependWithDash(prefix, Format("%s-ip", cluster))
}

func ServicePrincipalName(cluster string) string {
	return Format("http://%s-principal", cluster)
}

func ServicePrincipalIdName(cluster string) string {
	return Format("%s-principal-id", cluster)
}

func ServicePrincipalPasswordName(cluster string) string {
	return Format("%s-principal-password", cluster)
}

func CertManagerDeploymentName() string {
	return "cert-manager"
}

func NginxDeploymentName(prefix string) string {
	return PrependWithDash(prefix, "nginx-ingress")
}

func KedaDeploymentName() string {
	return "keda"
}

func KuredDeploymentName() string {
	return "kured"
}

func VpaDeploymentName() string {
	return "vpa"
}

// LaterDo: Is there any way to determine this.
func DevOpsOrganizationName() string {
	return "NetsMS"
}

// LaterDo: Is there any way to determine this.
func DevOpsProjectName() string {
	return "PaymentServices"
}

func DevOpsUnixName(name string) string {
	return s.Replace(s.Replace(s.ToLower(name), " - ", " ", -1), "\\W", "-", -1)
}

func DevOpsServiceAccountName(name string) string {
	unixName := DevOpsUnixName(name)
	return Format("-devops-sa", unixName)
}

func DevOpsRoleBindingName(name string) string {
	unixName := DevOpsUnixName(name)
	return Format("-devops-rb", unixName)
}
