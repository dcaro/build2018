resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.prefix}"
  kubernetes_version  = "1.9.6"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = "${replace(var.admin_public_ssh_key, "\n", "")}"
    }
  }

  agent_pool_profile {
    name            = "nodepool"
    count           = "${var.agents_count}"
    vm_size         = "${var.agents_size}"
    os_type         = "Linux"
    os_disk_size_gb = 50
  }

  service_principal {
    client_id     = "${var.service_principal_client_id}"
    client_secret = "${var.service_principal_client_secret}"
  }

  tags = "${var.tags}"
}
