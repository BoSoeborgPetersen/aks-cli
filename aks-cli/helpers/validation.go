package helpers

import (
	"errors"
	"fmt"
	"strconv"
	"strings"

	c "github.com/spf13/cobra"
)

func RequiredAll(pargs ...c.PositionalArgs) c.PositionalArgs {
	return func(cmd *c.Command, args []string) error {
		for _, parg := range pargs {
			if err := parg(cmd, args); err != nil {
				return err
			}
		}
		if err := c.ExactArgs(len(pargs))(cmd, args); err != nil {
			return err
		}
		return nil
	}
}

func RequiredArg(argName string) func(*c.Command, []string) error {
	return RequiredArgAt(argName, 0)
}

func RequiredArgAt(argName string, index int) func(*c.Command, []string) error {
	return func(cmd *c.Command, args []string) error {
		if err := c.MinimumNArgs(index+1)(cmd, args); err != nil {
			return errors.New("Required " + argName + " not specified")
		}
		return nil
	}
}

func ValidKubectlResourceType(argName string, includeAll bool) func(*c.Command, []string) error {
	return ValidKubectlResourceTypeAt(argName, 0, includeAll)
}

func ValidKubectlResourceTypeAt(argName string, index int, includeAll bool) func(*c.Command, []string) error {
	resourceTypes := map[string]string{
		"all":                         "standard Kubernetes resources",
		"cert|certificate":            "Certificates",
		"challenge":                   "Challenges",
		"cm|configmap":                "ConfigMap",
		"ds|daemonset":                "DaemonSet",
		"deploy|deployment":           "Deployments",
		"ev|event":                    "Event",
		"hpa|horizontalpodautoscaler": "Horizontal Pod Autoscalers",
		"ing|ingress":                 "Ingress",
		"issuer":                      "Issuers",
		"ns|namespace":                "Namespace",
		"no|node":                     "Nodes",
		"order":                       "Orders",
		"po|pod":                      "Pods",
		"rs|replicaset":               "Replica Sets",
		"secret":                      "Secrets",
		"svc|service":                 "Services",
	}

	return ValidArgAt(argName, resourceTypes, index, includeAll)
}

func ValidArg(argName string, validTypes map[string]string, includeAll bool) func(*c.Command, []string) error {
	return ValidArgAt(argName, validTypes, 0, includeAll)
}

func ValidArgAt(argName string, validTypes map[string]string, index int, includeAll bool) func(*c.Command, []string) error {
	return func(cmd *c.Command, args []string) error {
		if err := c.MinimumNArgs(index+1)(cmd, args); err != nil {
			return errors.New("Required " + argName + " not specified")
		}

		if !includeAll {
			delete(validTypes, "all")
		}

		maxKeyLength := 0
		validType := false
		if !validType {
			for typeString := range validTypes {
				if len(typeString) > maxKeyLength {
					maxKeyLength = len(typeString)
				}
				if strings.Contains(typeString, "|") {
					for _, typeName := range strings.Split(typeString, "|") {
						if typeName == args[index] {
							validType = true
						}
					}
				} else {
					if typeString == args[index] {
						validType = true
					}
				}
			}
		}

		if !validType {
			fmt.Println("Valid types: ")
			for key, value := range validTypes {
				command := strings.Title(strings.Fields(cmd.Use)[0])
				fmt.Println(fmt.Sprintf("  % -"+strconv.Itoa(maxKeyLength)+"s %s %s", key, command, value))
			}
			return errors.New("Required " + argName + " is invalid type")
		}

		return nil
	}
}
