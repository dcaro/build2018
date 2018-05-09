provider "azurerm" {
  version = "=1.4.0"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

module "ssh-key" {
  source = "./modules/ssh-key"
}

module "kubernetes" {
  source                          = "./modules/kubernetes-cluster"
  prefix                          = "${var.prefix}"
  resource_group_name             = "${azurerm_resource_group.main.name}"
  location                        = "${azurerm_resource_group.main.location}"
  admin_username                  = "microsoftbuild"
  admin_public_ssh_key            = "${module.ssh-key.public_ssh_key}"
  agents_size                     = "Standard_F2"
  service_principal_client_id     = "${var.ARM_CLIENT_ID}"
  service_principal_client_secret = "${var.ARM_CLIENT_SECRET}"
}

module "redis-cache" {
  source              = "./modules/redis-cache"
  prefix              = "${var.prefix}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}
