# build2018

This repository contains a demonstration presented at Microsoft Build 2018 that uses Terraform to run, deploy and update an application on a Kubernetes cluster on Azure.

## Run the demonstration

### Prerequisites

- **Azure subscription**: If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free) before you begin.

- **Install Terraform**: Follow the directions in the article, [Terraform and configure access to Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

### Configure your environment

- **DataDog API Key**: This demonstration instantiate monitoring of the Kubernetes cluster with [DataDog](https://www.datadoghq.com/). In order to enable the monitoring of your cluster you need and API Key from DataDog and set this key in the following environment variable:

```
TF_VAR_DATADOG_API_KEY=xxxxxxxxxxxxx
```

- **Authenticate with azure**: Authenticate against the azure using a [Service Principal](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html) and set the following environment variables: 

```
TF_VAR_ARM_CLIENT_ID=xxxxxxxxxxxxxxx
TF_VAR_ARM_CLIENT_SECRET=xxxxxxxxxxxxxxx
```


### Deploy the infrastructure

- Clone the current repository

```
git clone https://github.com/dcaro/build2018.git
```

- Go into the `0-demo` folder and run the following command 

```
terraform apply -var location=centralus
```

You can specify any location that supports AKS. 
Confirm the deployment when asked to do so. The deployment will take some minutes to complete.

### Deploy the application

- Edit the ```2-kubernetes.tf``` file to deploy the application using the terraform provider for Kubernetes. Remove the comment on line 1 and 48 and save the file.

- Run the following command to apply only the differences from the previous step: 

```
terraform apply -var location=centralus
```

Note and save the FQDN of the application displayed as an output of the command. 

### Check the deployment of the app

- Run the following command to get the logs of the HTTP Application Routing DNS:

```
kubectl logs -f deploy/addon-http-application-routing-external-dns -n kube-system
```

- Try to access the application using the DNS name that you noted earlier. 

### Scale out the application deployment

- Run the following command: 

```
terraform apply -var app_replicas=3
```
