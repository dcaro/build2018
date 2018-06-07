resource "local_file" "kubeconfig" {
  content  = "${var.raw_kube_config}"
  filename = "${path.module}/kubeconfig"
}

# Obtaining the DNS zone specific to the cluster
data "external" "httpapplicationrouting" {
  program = ["az", "resource", "show", "--id", "${var.kubernetes_cluster_id}", "-o", "json", "--api-version", "2018-03-31", "--query", "properties.addonProfiles.httpApplicationRouting.config"]
}

# Creating the ingress definition
data "template_file" "ingress" {
  template = "${file("${path.module}/ingress.tpl")}"

  vars {
    CLUSTER_SPECIFIC_DNS_ZONE = "${lookup(data.external.httpapplicationrouting.result, "HTTPApplicationRoutingZoneName")}"
    app_name                  = "${var.app_name}"
  }
}

# Creating the ingress on the cluster
resource "local_file" "ingress" {
  content  = "${data.template_file.ingress.rendered}"
  filename = "${path.module}/ingress.yaml"

  provisioner "local-exec" {
    command = "kubectl create -f ${path.module}/ingress.yaml --kubeconfig ${path.module}/kubeconfig"
  }
}

output "application_dns_name" {
  value = "${lookup(data.external.httpapplicationrouting.result, "HTTPApplicationRoutingZoneName")}"
}
