#!/bin/bash

. ../util.sh

run "az aks get-credentials -n brk2121-aks -g brk2121-resources"

run "clear" 

desc "#1 - What is running on the cluster?"

run "kubectl get pods"

run "kubectl get deployments --namespace kube-system"

desc "#2 - Let's edit our definition to deploy the application"

run "terraform plan"

run "terraform apply"

run "clear"

desc "#3 - Let's get the logs of the external DNS and ingress controller"

run "kubectl logs -f deploy/addon-http-application-routing-external-dns -n kube-system"

run "kubectl logs -f deploy/addon-http-application-routing-nginx-ingress-controller -n kube-system"

run "clear"

desc "let see if the app works !!!"

desc "Now you can connect to http://aka.ms/tfk8"

run "clear"

desc "#4 - Too many people here let's scale the application!"

run "terraform plan -var app_replicas=3" 

run "terraform apply -var app_replicas=3" 

run "kubectl get pods"
