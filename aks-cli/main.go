// --- NEW ---
// TODO: Maybe add examples

// TODO: Generalize code for Helm chart operations

// LaterDo: Improve functions for working with multiple nginx's in a cluster

// LaterDo: Add nodepools to functions

// LaterDo: Add better examples to 'using' descriptions.

// LaterDo: Add deployment history operations (e.g. aks deployment history consents).

// LaterDo: Incorporate DevOps functions into all related functions
//          - e.g. update DevOps Service Connection when AKS cluster service principal is updated.
//          - e.g. update DevOps Variable Group (for Key Vault access) when Azure Key Vault service principal is updated.

// MaybeDo: Use splatting to simplify long commands with many parameters (e.g. az aks create -c -n -g -?)..

// DoNotDo: Add Azure "Get PublishSettings file" function (requires classic azure cli), using this apparently very secret link 'https://portal.azure.com/#blade/Microsoft_Azure_ClassicResources/PublishingProfileBlade'

package main

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler/node"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler/pod"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/certManager"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/environment"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/environmentChecks"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/environmentKubernetes"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/pipeline"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/serviceConnection"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/helm"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/identity"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/insights"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/keda"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/kured"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/lastApplied"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/monitoring"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/nginx"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/pod"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/registry"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/scale"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/servicePrincipal"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/state"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/trafficManager"
	_ "github.com/BoSoeborgPetersen/aks-cli/cmd/vpa"
)

func main() {
	cmd.Execute()
}
