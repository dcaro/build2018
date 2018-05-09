/*
# Configuration of the kubernetes provider - note the absence of kubeconfig file
provider "kubernetes" {
  version                = "=1.1.0"
  host                   = "${module.kubernetes.host}"
  username               = "${module.kubernetes.username}"
  password               = "${module.kubernetes.password}"
  client_certificate     = "${base64decode(module.kubernetes.client_certificate)}"
  client_key             = "${base64decode(module.kubernetes.client_key)}"
  cluster_ca_certificate = "${base64decode(module.kubernetes.cluster_ca_certificate)}"
  load_config_file       = false
}

variable "app_name" {
  default = "msbuild"
}

# Deploy and ingress to configure the ingress controller
module "kubernetes-ingress" {
  source                = "./modules/kubernetes-ingress"
  kubernetes_cluster_id = "${module.kubernetes.cluster_id}"
  raw_kube_config       = "${module.kubernetes.raw_kube_config}"
  app_name              = "${var.app_name}"
}

# Deploy the application made of the replication controller and the service
module "voting-app" {
  source           = "./modules/voting-app"
  app_name         = "${var.app_name}"
  redis_access_key = "${module.redis-cache.primary_access_key}"
  redis_hostname   = "${module.redis-cache.hostname}"
  replicas         = "${var.app_replicas}"
}
*/

variable "DATADOG_API_KEY" {}

# Add monitoring capabilities for DataDog
module "monitoring" {
  source          = "./modules/datadog-agent"
  datadog_api_key = "${var.DATADOG_API_KEY}"
  raw_kube_config = "${module.kubernetes.raw_kube_config}"
}
