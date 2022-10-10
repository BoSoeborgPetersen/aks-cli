package helpers

import (
	"encoding/json"
	"fmt"
	"os"
)

//	type Subscriptions struct {
//		Subscriptions []Subscription
//	}
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

// type Deployment struct {

// }

func GetEnv[T any](name string, t T) T {
	DeserializeB(HandleError(os.ReadFile("aks.config")), &t)
	return t
}

func GetGlobalCurrentCluster() Cluster {
	return GetEnv("GlobalCurrentCluster", Cluster{})
}

func SetEnv[T any](name string, t T) {
	jsonBytes, err := json.Marshal(t)
	jsonString := string(jsonBytes)
	if err != nil {
		fmt.Print("Error: ")
		fmt.Println(err.Error())
	}
	// fmt.Print("SetEnv: ")
	// fmt.Println(jsonString)

	f, _ := os.Create("aks.config")
	f.WriteString(jsonString)
	// os.Setenv(name, jsonString)
}

func SetGlobalCurrentCluster(t Cluster) {
	SetEnv("GlobalCurrentCluster", t)
}

// func GetGlobalCurrentCluster() Cluster {
// 	return Get("GlobalCurrentCluster")
// 	// cluster := Cluster{}
// 	// GetEnv("GlobalCurrentCluster", &cluster)
// 	// return cluster
// }

var GlobalSubscriptionUsedForClusters Subscription
var GlobalClusters []Cluster

// var GlobalCurrentCluster Cluster
var GlobalCurrentSubscription Subscription
var GlobalSubscriptions []Subscription
var GlobalCurrentUsage string

var GlobalSubscriptionUsedForDeployments Subscription
var GlobalClusterUsedForDeployments Cluster
// var GlobalDeployments []Deployment
var GlobalDeployments []string

var GlobalStateDebugging bool
var GlobalStateWhatIf bool
var GlobalStateVerbose bool
var GlobalDefaultResourceGroup string

var Verbose bool
var Debug bool
var WhatIf bool

func DebugString() string {
	if Debug {
		return " --debug"
	}
	return ""
}

func KubeDebugString() string {
	if Debug {
		return " --v=4"
	}
	return ""
}
