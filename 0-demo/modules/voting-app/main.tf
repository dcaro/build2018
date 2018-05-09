locals {
  pod_name = "${var.app_name}-front"
  pod_port = 80
}

resource "kubernetes_replication_controller" "votingapp-front" {
  metadata {
    name = "${local.pod_name}"

    labels {
      app = "${local.pod_name}"
    }
  }

  spec {
    selector {
      app = "${local.pod_name}"
    }

    replicas = "${var.replicas}"

    template {
      container {
        name  = "${local.pod_name}"
        image = "dcaro/azure-vote-front"

        port {
          container_port = "${local.pod_port}"
        }

        resources {
          limits {
            cpu = "500m"
          }

          requests {
            cpu = "250m"
          }
        }

        env {
          name  = "REDIS"
          value = "${var.redis_hostname}"
        }

        env {
          name  = "REDIS_PWD"
          value = "${var.redis_access_key}"
        }
      }
    }
  }
}

resource "kubernetes_service" "votingapp-front" {
  metadata {
    name = "${local.pod_name}"
  }

  spec {
    selector {
      app = "${kubernetes_replication_controller.votingapp-front.metadata.0.labels.app}"
    }

    port {
      port = "${local.pod_port}"
    }

    type = "ClusterIP"
  }
}
