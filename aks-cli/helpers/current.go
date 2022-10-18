package helpers

import (
	"fmt"

	"github.com/manifoldco/promptui"
)

func SubscriptionMenu() Subscription {
	// subscriptions := make([]Subscription, 0)
	subscriptions := GetGlobalSubscriptions()
	if subscriptions == nil || len(subscriptions) == 0 {
		jsonString := AzQueryP("account list --all", AzFlags{Query: "sort_by([], &name)[*].{Id:id, Name:name, TenantId:tenantId}"})

		Deserialize(jsonString, &subscriptions)
		SetGlobalSubscriptions(subscriptions)
	}

	if len(subscriptions) == 1 {
		return subscriptions[0]
	}

	Check(len(subscriptions) > 0, "No Azure subscriptions")

	templates := &promptui.SelectTemplates{
		Label:    "{{ .Name }}?",
		Active:   "\U0001F336 {{ .Name | cyan }} ({{ .Id | red }})",
		Inactive: "  {{ .Name | cyan }} ({{ .Id | red }})",
		Selected: "\U0001F336 {{ .Name | red | cyan }}",
	}

	prompt := promptui.Select{
		Label:     "Select subscription",
		Items:     subscriptions,
		Templates: templates,
	}

	i, _, _ := prompt.Run()

	return subscriptions[i]
}

func SwitchCurrentSubscription(clear bool) {
	if clear {
		ClearHost()
	}

	WriteInfo("Choose Azure Subscription: ")

	var currentSubscription = SubscriptionMenu()
	SetGlobalCurrentSubscription(currentSubscription)

	AzCommand(Format("account set -s %s", currentSubscription.Id))
}

// NOWDO: Call before any command except switch
func CheckCurrentSubscription() {
	check := GetGlobalCurrentSubscription() != (Subscription{}) //|| params[0] == "switch"
	Check(check, "No current Azure subscription, run 'aks switch subscription' to select a current Azure subscription")
}

func CurrentSubscription() string {
	return GetGlobalCurrentSubscription().Id
}

func CurrentSubscriptionName() string {
	return GetGlobalCurrentSubscription().Name
}

func CurrentSubscriptionTenantId() string {
	return GetGlobalCurrentSubscription().TenantId
}

func ClusterMenu(refresh bool) Cluster {
	currentSubscription := GetGlobalCurrentSubscription()
	Check(currentSubscription != Subscription{}, "No Azure subscriptions")

	// clusters := make([]Cluster, 0)
	clusters := GetGlobalClusters()
	test1 := clusters == nil || len(clusters) == 0
	test2 := GetGlobalSubscriptionUsedForClusters() == Subscription{}
	test3 := GetGlobalCurrentSubscription() != GetGlobalSubscriptionUsedForClusters()
	if refresh || test1 || test2 || test3 {
		SetGlobalSubscriptionUsedForClusters(GetGlobalCurrentSubscription())
		jsonString := AzQueryP("aks list", AzFlags{Query: "sort_by([], &name)[*].{ResourceGroup:resourceGroup, NodeResourceGroup:nodeResourceGroup, Name:name, Location:location, Fqdn:fqdn}"})

		Deserialize(jsonString, &clusters)

		SetGlobalClusters(clusters)
	}

	if len(clusters) == 1 {
		fmt.Println(Format("Only 1 cluster: '%s', it was choosen", clusters[0].Name))
		return clusters[0]
	}

	Check(len(clusters) > 0, "No AKS clusters in Azure subscription")

	templates := &promptui.SelectTemplates{
		Label:    "{{ .Name }}?",
		Active:   "\U0001F336 {{ .Name | cyan }} ({{ .Location | red }})",
		Inactive: "  {{ .Name | cyan }} ({{ .Location | red }})",
		Selected: "\U0001F336 {{ .Name | red | cyan }}",
	}

	prompt := promptui.Select{
		Label:     "Select cluster",
		Items:     clusters,
		Templates: templates,
	}

	i, _, _ := prompt.Run()

	return clusters[i]
}

func SwitchCurrentCluster(clear bool, refresh bool) {
	if clear {
		ClearHost()
	}

	WriteInfo("Choose Kubernetes Cluster: ")

	SetGlobalCurrentCluster(ClusterMenu(refresh))

	// NOWDO: Be quiet!!!
	// AzAksCurrentCommand("get-credentials -a --overwrite-existing > $1")
	AzAksCurrentCommand("get-credentials -a --overwrite-existing")

	UpdateShellWindowTitle()

	if clear {
		ClearHost()
	}
}

func SwitchCurrentClusterTo(resourceGroup string) {
	clusterName := ClusterName(resourceGroup)
	SetGlobalSubscriptionUsedForClusters(GetGlobalCurrentSubscription())
	SetGlobalClusters(DeserializeT[[]Cluster](AzAksQuery("list")))
	SetGlobalCurrentCluster(First(GetGlobalClusters(), func(c Cluster) bool { return c.Name == clusterName }))

	AzAksCommand(Format("get-credentials -g %s -n %s -a", resourceGroup, clusterName))

	UpdateShellWindowTitle()
}

func CheckCurrentCluster() {
	Check(GetGlobalCurrentCluster() != (Cluster{}), "No current AKS cluster, run 'aks switch -cluster' to select a current AKS cluster")
}

func CheckCurrentClusterOrVariable(variable string, variableName string) {
	check := IsSet(GetGlobalCurrentCluster() != (Cluster{})) || IsSet(variable)
	Check(check, Format("The following argument is required: %s\nAlternatively run 'aks switch' to select a current AKS cluster, then the current cluster '%s' will be used", variableName, variableName))
}

// CONTINUE

func CurrentClusterResourceGroup() string {
	return GetGlobalCurrentCluster().ResourceGroup
}

func CurrentClusterName() string {
	return GetGlobalCurrentCluster().Name
}

func CurrentClusterLocation() string {
	return GetGlobalCurrentCluster().Location
}

func CurrentClusterFqdn() string {
	return GetGlobalCurrentCluster().Fqdn
}

func SetCurrentCluster(cluster Cluster) {
	SetGlobalCurrentCluster(cluster)
}

// func DeploymentMenu(namespace string) string {
// 	CheckCurrentSubscription()
// 	CheckCurrentCluster()

// 	if GlobalSubscriptionUsedForDeployments == (Subscription{}) || GlobalClusterUsedForDeployments == (Cluster{}) || GlobalDeployments == nil || (GlobalCurrentSubscription != GlobalSubscriptionUsedForDeployments) || (GetGlobalCurrentCluster() != GlobalClusterUsedForDeployments) {
// 		GlobalSubscriptionUsedForDeployments = GlobalCurrentSubscription
// 		GlobalClusterUsedForDeployments = GetGlobalCurrentCluster()
// 		GlobalDeployments = Fields(KubectlQueryF("get deploy", KubectlFlags{Namespace: namespace, JsonPath: "{.items[*].metadata.name}"}))
// 	}

// 	if len(GlobalDeployments) == 1 {
// 		return GlobalDeployments[0]
// 	}

// 	Check(len(GlobalDeployments) > 0, "No Kubernetes deployments in AKS cluster")

// 	templates := &promptui.SelectTemplates{
// 		Label:    "{{ .Name }}?",
// 		Active:   "\U0001F336 {{ .Name | cyan }}",
// 		Inactive: "  {{ .Name | cyan }}",
// 		Selected: "\U0001F336 {{ .Name | red | cyan }}",
// 	}

// 	prompt := promptui.Select{
// 		Label:     "Select deployment",
// 		Items:     GlobalDeployments,
// 		Templates: templates,
// 	}

// 	i, _, _ := prompt.Run()

// 	return GlobalDeployments[i]
// }

// func ChooseDeployment(deployment string, namespace string) string {
// 	if deployment == "" {
// 		WriteInfo("Choose AKS Deployment: ")
// 		return DeploymentMenu(namespace)
// 	}
// 	return ""
// }
