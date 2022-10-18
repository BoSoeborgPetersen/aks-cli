package helpers

import (
	c "github.com/spf13/cobra"
	v "github.com/spf13/viper"
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

func GetGlobalSubscriptions() []Subscription {
	return GetEnv("GlobalSubscriptions", []Subscription{})
}
func SetGlobalSubscriptions(t []Subscription) {
	v.Set("GlobalSubscriptions", t)
}

func GetGlobalCurrentSubscription() Subscription {
	return GetEnv("GlobalCurrentSubscription", Subscription{})
}
func SetGlobalCurrentSubscription(t Subscription) {
	v.Set("GlobalCurrentSubscription", t)
}

// ----------------

func GetGlobalSubscriptionUsedForClusters() Subscription {
	return GetEnv("GlobalSubscriptionUsedForClusters", Subscription{})
}
func SetGlobalSubscriptionUsedForClusters(t Subscription) {
	v.Set("GlobalSubscriptionUsedForClusters", t)
}

func GetGlobalClusters() []Cluster {
	return GetEnv("GlobalClusters", []Cluster{})
}
func SetGlobalClusters(t []Cluster) {
	v.Set("GlobalClusters", t)
}

func GetGlobalCurrentCluster() Cluster {
	return GetEnv("GlobalCurrentCluster", Cluster{})
}
func SetGlobalCurrentCluster(t Cluster) {
	v.Set("GlobalCurrentCluster", t)
}

// ----------------

// func GetGlobalSubscriptionUsedForDeployments() Subscription {
// 	return GetEnv("GlobalSubscriptionUsedForDeployments", Subscription{})
// }
// func SetGlobalSubscriptionUsedForDeployments(t Subscription) {
// 	v.Set("GlobalSubscriptionUsedForDeployments", t)
// }

// func GetGlobalClusterUsedForDeployments() Cluster {
// 	return GetEnv("GlobalClusterUsedForDeployments", Cluster{})
// }
// func SetGlobalClusterUsedForDeployments(t Cluster) {
// 	v.Set("GlobalClusterUsedForDeployments", t)
// }

// func GetGlobalDeployments() []string {
// 	return GetEnv("GlobalDeployments", []string{})
// }
// func SetGlobalDeployments(t []string) {
// 	v.Set("GlobalDeployments", t)
// }

// ----------------------------------------------

func GetGlobalDebuggingState() bool {
	return v.GetBool("GlobalDebuggingState")
}
func SetGlobalDebuggingState(t bool) {
	v.Set("GlobalDebuggingState", t)
}

func GetGlobalWhatIfState() bool {
	return v.GetBool("GlobalWhatIfState")
}
func SetGlobalWhatIfState(t bool) {
	v.Set("GlobalWhatIfState", t)
}

func GetGlobalVerboseState() bool {
	return v.GetBool("GlobalVerboseState")
}
func SetGlobalVerboseState(t bool) {
	v.Set("GlobalVerboseState", t)
}

func GetGlobalDefaultResourceGroup() string {
	return v.GetString("GlobalDefaultResourceGroup")
}
func SetGlobalDefaultResourceGroup(t string) {
	v.Set("GlobalDefaultResourceGroup", t)
}

// --------------------------------------------

var Verbose bool
var Debug bool
var WhatIf bool

func DebugString() string {
	return If(Debug, " --debug")
}

func KubeDebugString() string {
	return If(Debug, " --v=4")
}

//---------------------------------------------

// TODO: Change to hold Cobra Cmd, then use it for flag func's and to print help in func
// var GlobalCurrentUsage string
var GlobalCurrentCmd *c.Command