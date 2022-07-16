terraform {
  required_version = "~> 1.2.0"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

locals {
  common_labels = {
    app = "vector"
  }
  common_metadata = {
    name      = "vector"
    namespace = "something"
    labels    = locals.common_labels
  }
}

resource "kubernetes_namespace" "vector" {
  metadata = local.common_metadata
}

resource "kubernetes_daemonset" "vector" {
  metadata = local.common_metadata

  spec {
    selector {
      match_labels = common_labels
    }

    template {
      metadata = common_metadata

      spec {
        container {
          image = "timberio/vector:0.23.0-distroless-libc"
          image_pull_policy = "IfNotPresent"
          args = [
            "--config-dir",
            "/etc/vector"
          ]

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

        }
      }
    }
  }
}
