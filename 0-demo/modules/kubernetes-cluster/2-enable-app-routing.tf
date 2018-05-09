# Enable HTTPApplicationRouting on the AKS cluster using ARM embeded
resource "azurerm_template_deployment" "app-routing" {
  name                = "enable-app-routing"
  resource_group_name = "${var.resource_group_name}"

  template_body = "${file("${path.module}/httpApplicationRouting.json")}"

  parameters = {
    "resourceName"                 = "${azurerm_kubernetes_cluster.main.name}"
    "dnsPrefix"                    = "${azurerm_kubernetes_cluster.main.dns_prefix}"
    "servicePrincipalClientId"     = "${var.service_principal_client_id}"
    "servicePrincipalClientSecret" = "${var.service_principal_client_secret}"
    "agentVMSize"                  = "${azurerm_kubernetes_cluster.main.agent_pool_profile.0.vm_size}"
  }

  deployment_mode = "Incremental"
}
