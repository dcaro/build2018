#/bin/bash 

# Clean the AKS Cluster 
# kubectl delete daemonset/datadog-agent --namespace kube-system

kubectl delete rc/msbuild-front

kubectl delete  ingress/msbuild-front

kubectl delete svc/msbuild-front

# Remove the terraform.tfstate & tfstate.backup files 
# Copy the backup/tfstate file 

rm 0-demo/terraform.tfstate

rm 0-demo/terraform.tfstate.backup 

cp ./backup/terraform.tfstate ./0-demo/terraform.tfstate
