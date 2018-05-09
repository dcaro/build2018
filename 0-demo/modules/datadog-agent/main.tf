resource "local_file" "kubeconfig" {
  content  = "${var.raw_kube_config}"
  filename = "${path.module}/kubeconfig"
}

# Creating the ingress definition
data "template_file" "datadog" {
  template = "${file("${path.module}/datadog-agent.tpl")}"

  vars {
    DATADOG_API_KEY_VALUE = "${var.datadog_api_key}"
  }
}

# Creating the ingress on the cluster
resource "local_file" "datadog" {
  content  = "${data.template_file.datadog.rendered}"
  filename = "${path.module}/datadog-agent.yaml"

  provisioner "local-exec" {
    command = "kubectl create -f ${path.module}/datadog-agent.yaml --kubeconfig ${path.module}/kubeconfig"
  }
}
