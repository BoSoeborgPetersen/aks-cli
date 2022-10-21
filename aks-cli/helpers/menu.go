package helpers

import (
	"fmt"

	"github.com/manifoldco/promptui"
)

func Description(desc string) string {
	return Logo() + "\n" + desc
}

func Logo() string {
	return `
     __       __   ___   _______
    /  \     |  | /  /  |  _____|
   /    \    |  |/  /   |  |____
  /  /\  \   |     |    |____   |
 /  ____  \  |  |\  \    ____|  |
/__/    \__\ |__| \__\  |_______|
`
}

func Tools() {
	fmt.Println("")
	fmt.Println("List of available tools:")
	fmt.Println("")
	fmt.Println("    a / aks              : AKS CLI")
	fmt.Println("    az                   : Azure CLI")
	fmt.Println("    az bicep             : Azure Bicep CLI extension")
	fmt.Println("    az devops            : Azure DevOps CLI extension")
	fmt.Println("    ctx / kubectx        : Kubectx")
	fmt.Println("    curl                 : Curl")
	fmt.Println("    git                  : Git")
	fmt.Println("    h / helm             : Helm CLI")
	fmt.Println("    helm whatup          : Helm WhatUp CLI extension")
	fmt.Println("    k / kubectl          : Kubernetes CLI")
	fmt.Println("    kubectl cert-manager : Kubernetes Cert-Manager CLI extension")
	fmt.Println("    kubectl node-shell   : NodeShell")
	fmt.Println("    k9s                  : K9s")
	fmt.Println("    kube-prompt          : Kube-prompt")
	fmt.Println("    kubeaudit            : KubeAudit")
	fmt.Println("    kubebox              : KubeBox")
	fmt.Println("    kubescape            : KubeScape")
	fmt.Println("    kubespy              : KubeSpy")
	fmt.Println("    nano                 : Nano")
	fmt.Println("    ns / kubens          : Kubens")
	fmt.Println("    popeye               : Popeye")
	fmt.Println("    pwsh                 : PowerShell Core")
	fmt.Println("    stern                : Wercher/Stern")
	fmt.Println("")
}

func AreYouSure() bool {

	if BoolFlag("yes") {
		return true
	}

	// TODO: Maybe make text red
	templates := &promptui.PromptTemplates{
		Confirm: "{{ . | red }}",
	}

	prompt := promptui.Prompt{
		Label:     "Are you sure you want to proceed?",
		IsConfirm: true,
		// HideEntered: true,
		Templates: templates,
	}
	_, err := prompt.Run()

	return err == nil
}

// TODO: Maybe make text red
func WantToContinue(question string) bool {
	prompt := promptui.Prompt{
		Label:     "question, proceed?",
		IsConfirm: true,
	}

	result, err := prompt.Run()

	if err != nil {
		fmt.Printf("Prompt failed %v\n", err)
		return false
	}

	fmt.Printf("You choose %q\n", result)
	return true
}
