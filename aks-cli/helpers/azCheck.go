package helpers

func AzCheckSubscription(name string) {
	check := AzQueryP("account list", AzFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	Check(check, Format("Subscription '%s' does not exist", name))
}

func AzCheckLocation(name string) {
	check := AzQueryP("account list-locations", AzFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	Check(check, Format("Location '%s' does not exist", name))
}

func AzCheckUpgradableVersion(version string, preview bool) {
	version = CheckVersion(version, "")
	previewString := If(!preview, "!isPreview &&")
	check := AzAksCurrentQueryP("get-upgrades", AzAksFlags{Query: Format("controlPlaneProfile.upgrades[?%s kubernetesVersion=='%s'].kubernetesVersion", previewString, version), Output: "tsv"})
	Check(check, Format("Version '%s', is not an upgradable version", version))
}

func AzCheckResourceGroupP(name string, subscription string, location string) {
	// TODO: Change to if then append
	query := IfElse(location, Format("name=='%s'&&location=='%s'", name, location), Format("name=='%s'", name))
	check := AzQueryP("group list", AzFlags{Query: Format("[?%s].name", query), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Resource Group '%s' does not exist", name))
}

// TODO: Merge with AzCheckResourceGroupF
func AzCheckResourceGroup(name string, subscription string) {
	check := AzQueryP("group list", AzFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Resource Group '%s' does not exist", name))
}

// TODO: Merge with AzCheckResourceGroupF
func AzCheckNotResourceGroup(name string) {
	check := AzQueryP("group list", AzFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	CheckNot(check, Format("Resource Group '%s' already exist", name))
}

func AzCheckServicePrincipal(name string) {
	check := AzQueryP(Format("ad sp list --display-name %s", name), AzFlags{Query: "[].displayName", Output: "tsv"})
	Check(check, Format("Service Principal '%s' does not exist", name))
}

func AzCheckVirtualMachineSize(location string, name string) {
	check := name == "" || AzQueryP(Format("vm list-sizes -l %s", location), AzFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"}) != ""
	Check(check, Format("Virtual Machine Size '%s' does not exist", name))
}

func AzCheckLoadBalancerSku(sku string) {
	check := sku == "basic" || sku == "standard"
	Check(check, Format("Load Balancer SKU '%s' does not exist", sku))
}

func AzCheckContainerRegistry(name string, subscription string) {
	check := AzQueryP("acr list", AzFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Azure Container Registry '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckNotContainerRegistry(name string, subscription string) {
	check := AzQueryP("acr list", AzFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	CheckNot(check, Format("Azure Container Registry '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckKeyVault(name string, subscription string) {
	check := AzQueryP("keyvault list", AzFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Azure Key Vault '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckNotKeyVault(name string, subscription string) {
	check := AzQueryP("keyvault list", AzFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	CheckNot(check, Format("Azure Key Vault '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckNodeAutoscaler() {
	check := AzAksCurrentQueryP("show", AzAksFlags{Query: "agentPoolProfiles[?enableAutoScaling]", Output: "tsv"})
	Check(check, "Node autoscaler does not exist")
}

func AzCheckRoleAssignment(id string, subscriptionId string, resourceGroup string) {
	check := AzQueryP(Format("role assignment list --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, subscriptionId, resourceGroup), AzFlags{Output: "tsv"})
	Check(check, "Identity role assignment does not exist")
}

func AzCheckInsights(resourceGroup string, name string) {
	check := AzQueryP(Format("monitor log-analytics workspace list -g %s", resourceGroup), AzFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	Check(check, "Log Analytics Workspace does not exist")
}

func AzCheckMonitoringAddon() {
	check := AzAksCurrentQueryP("show", AzAksFlags{Query: "addonProfiles.omsagent.enabled", Output: "tsv"}) == "true"
	Check(check, "Monitoring Addon has not been added")
}
