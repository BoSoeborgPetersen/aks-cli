package helpers

type AzCommandFlags struct {
	Query  string
	Output string
}

func AzCommand(command string) string {
	return AzCommandF(command, AzCommandFlags{})
}

func AzCommandF(command string, f AzCommandFlags) string {
	// queryString := ConditionalOperator(f.Query, Format(" --query \"%s\"", f.Query))
	queryString := ConditionalOperatorFormat(f.Query, " --query \"%s\"")
	// outputString := ConditionalOperator(f.Output, Format(" -o %s", f.Output))
	outputString := ConditionalOperatorFormat(f.Output, " -o %s")

	return ExecuteCommand(Format("az %s%s%s%s", command, queryString, outputString, DebugString()))
}

type AzAksCommandFlags struct {
	Location string
	Version  string
	Query    string
	Output   string
}

func AzAksCommand(command string) string {
	return AzAksCommandF(command, AzAksCommandFlags{})
}

func PrintAzAksCommandF(command string, f AzAksCommandFlags) {
	Write(AzAksCommandF(command, f))
}

func AzAksCommandF(command string, f AzAksCommandFlags) string {
	// locationString := ConditionalOperator(f.Location, Format(" -l %s", f.Location))
	locationString := ConditionalOperatorFormat(f.Location, " -l %s")
	// versionString := ConditionalOperator(f.Version, Format(" -k %s", f.Version))
	versionString := ConditionalOperatorFormat(f.Version, " -k %s")

	return AzCommandF(Format("aks %s%s%s", command, locationString, versionString), AzCommandFlags{Query: f.Query, Output: f.Output})
}

func PrintAzAksCurrentCommand(command string) {
	Write(AzAksCurrentCommand(command))
}

func AzAksCurrentCommand(command string) string {
	return AzAksCurrentCommandF(command, AzAksCommandFlags{})
}

func PrintAzAksCurrentCommandF(command string, f AzAksCommandFlags) {
	Write(AzAksCurrentCommandF(command, f))
}

func AzAksCurrentCommandF(command string, f AzAksCommandFlags) string {
	return AzAksCommandF(Format("%s -g %s -n %s", command, CurrentClusterResourceGroup(), CurrentClusterName()), f)
}

type AzQueryFlags struct {
	Query        string
	Subscription string
	Output       string
}

func AzQuery(command string) string {
	return AzQueryF(command, AzQueryFlags{})
}

func AzQueryF(command string, f AzQueryFlags) string {
	// queryString := ConditionalOperator(f.Query, Format(" --query \"%s\"", f.Query))
	queryString := ConditionalOperatorFormat(f.Query, " --query \"%s\"")
	// subscriptionString := ConditionalOperator(f.Subscription, Format(" --subscription '%s'", f.Subscription))
	subscriptionString := ConditionalOperatorFormat(f.Subscription, " --subscription '%s'")
	// LaterDo: Try to avoid setting tsv all the time
	// outputString := ConditionalOperator(f.Output, Format(" -o %s", f.Output))
	outputString := ConditionalOperatorFormat(f.Output, " -o %s")
	// outputString := ConditionalOperatorOr(f.Output, Format(" -o %s", f.Output), " -o tsv")

	return ExecuteQuery(Format("az %s%s%s%s%s", command, queryString, subscriptionString, outputString, DebugString()))
}

type AzAksQueryFlags struct {
	Location string
	Version  string
	Query    string
	Output   string
}

func AzAksQuery(command string) string {
	return AzAksQueryF(command, AzAksQueryFlags{})
}

func AzAksQueryF(command string, f AzAksQueryFlags) string {
	// locationString := ConditionalOperator(f.Location, Format(" -l %s", f.Location))
	locationString := ConditionalOperatorFormat(f.Location, " -l %s")
	// versionString := ConditionalOperator(f.Version, Format(" -k %s", f.Version))
	versionString := ConditionalOperatorFormat(f.Version, " -k %s")

	return AzQueryF(Format("aks %s%s%s", command, locationString, versionString), AzQueryFlags{Query: f.Query, Output: f.Output})
}

func AzAksCurrentQuery(command string) string {
	return AzAksCurrentQueryF(command, AzAksQueryFlags{})
}

func AzAksCurrentQueryF(command string, f AzAksQueryFlags) string {
	return AzAksQueryF(Format("%s -g %s -n %s", command, CurrentClusterResourceGroup(), CurrentClusterName()), f)
}

func AzCheckSubscription(name string) {
	check := AzQueryF("account list", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	Check(check, Format("Subscription '%s' does not exist", name))
}

func AzCheckLocation(name string) {
	check := AzQueryF("account list-locations", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	Check(check, Format("Location '%s' does not exist", name))
}

func AzCheckUpgradableVersion(version string, preview bool) {
	version = CheckVersion(version, "")

	previewString := ConditionalOperator(!preview, "!isPreview &&")
	check := AzAksCurrentQueryF("get-upgrades", AzAksQueryFlags{Query: Format("controlPlaneProfile.upgrades[?%s kubernetesVersion=='%s'].kubernetesVersion", previewString, version), Output: "tsv"})
	Check(check, Format("Version '%s', is not an upgradable version", version))
}

func AzCheckResourceGroupF(name string, subscription string, location string) {
	query := ConditionalOperatorOr(location, Format("name=='%s'&&location=='%s'", name, location), Format("name=='%s'", name))
	check := AzQueryF("group list", AzQueryFlags{Query: Format("[?%s].name", query), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Resource Group '%s' does not exist", name))
}

func AzCheckResourceGroup(name string, subscription string) {
	check := AzQueryF("group list", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Resource Group '%s' does not exist", name))
}

func AzCheckNotResourceGroup(name string) {
	check := AzQueryF("group list", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	CheckNot(check, Format("Resource Group '%s' already exist", name))
}

func AzCheckServicePrincipal(name string) {
	check := AzQueryF(Format("ad sp list --display-name %s", name), AzQueryFlags{Query: "[].displayName", Output: "tsv"})
	Check(check, Format("Service Principal '%s' does not exist", name))
}

func AzCheckVirtualMachineSize(location string, name string) {
	check := name == "" || AzQueryF(Format("vm list-sizes -l %s", location), AzQueryFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"}) != ""
	Check(check, Format("Virtual Machine Size '%s' does not exist", name))
}

func AzCheckLoadBalancerSku(sku string) {
	check := sku == "basic" || sku == "standard"
	Check(check, Format("Load Balancer SKU '%s' does not exist", sku))
}

func AzCheckContainerRegistry(name string, subscription string) {
	check := AzQueryF("acr list", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Azure Container Registry '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckNotContainerRegistry(name string, subscription string) {
	check := AzQueryF("acr list", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	CheckNot(check, Format("Azure Container Registry '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckKeyVault(name string, subscription string) {
	check := AzQueryF("keyvault list", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	Check(check, Format("Azure Key Vault '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckNotKeyVault(name string, subscription string) {
	check := AzQueryF("keyvault list", AzQueryFlags{Query: Format("[?name=='%s'].name", name), Subscription: subscription, Output: "tsv"})
	CheckNot(check, Format("Azure Key Vault '%s' in subscription '%s' does not exist", name, subscription))
}

func AzCheckNodeAutoscaler() {
	check := AzAksCurrentQueryF("show", AzAksQueryFlags{Query: "agentPoolProfiles[?enableAutoScaling]", Output: "tsv"})
	Check(check, "Node autoscaler does not exist")
}

func AzCheckRoleAssignment(id string, subscriptionId string, resourceGroup string) {
	check := AzQueryF(Format("role assignment list --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, subscriptionId, resourceGroup), AzQueryFlags{Output: "tsv"})
	Check(check, "Identity role assignment does not exist")
}

func AzCheckInsights(resourceGroup string, name string) {
	check := AzQueryF(Format("monitor log-analytics workspace list -g %s", resourceGroup), AzQueryFlags{Query: Format("[?name=='%s'].name", name), Output: "tsv"})
	Check(check, "Log Analytics Workspace does not exist")
}

func AzCheckMonitoringAddon() {
	check := AzAksCurrentQueryF("show", AzAksQueryFlags{Query: "addonProfiles.omsagent.enabled", Output: "tsv"}) == "true"
	Check(check, "Monitoring Addon has not been added")
}
