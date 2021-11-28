# Kubernetes job to seed the data
resource "kubernetes_job" "job" {
  metadata {
    name = "techchallengeapp"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          image   = "servian/techchallengeapp:latest" # Images is pulled from docker hub
          name    = "techchallengeapp"
          command = ["./TechChallengeApp"] # Though this is not required, added just in case
          args  = ["updatedb", "-s"]
          env {
            name = "VTT_DBUSER"
            value = "${azurerm_postgresql_server.pg_server.administrator_login}@${azurerm_postgresql_server.pg_server.name}"
          }
          env {
            name  = "VTT_DBPASSWORD"
            value = azurerm_postgresql_server.pg_server.administrator_login_password
          }
          env {
            name  = "VTT_DBNAME"
            value = azurerm_postgresql_database.pg_db.name
          }
          env {
            name  = "VTT_DBPORT"
            value = "5432"
          }
          env {
            name  = "VTT_DBHOST"
            value = azurerm_postgresql_server.pg_server.fqdn
          }
          env {
            name  = "VTT_LISTENHOST"
            value = "0.0.0.0"
          }
          env {
            name  = "VTT_LISTENPORT"
            value = var.port
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = true
}

# Kubernetes deployment for the application deployment
resource "kubernetes_deployment" "deploy" {
  metadata {
    name = "techchallengeapp"
    labels = {
      App = "techchallengeapp"
    }
  }
  
  lifecycle {
    ignore_changes = [
      # Number of replicas is controlled by
      # kubernetes_horizontal_pod_autoscaler, ignore the setting in this
      # deployment template.
      spec[0].replicas,
    ]
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "techchallengeapp"
      }
    }
    template {
      metadata {
        labels = {
          App = "techchallengeapp"
        }
      }
      spec {
        container {
          image   = "servian/techchallengeapp:latest" # Images is pulled from docker hub
          name    = "techchallengeapp"
          command = ["./TechChallengeApp"]   # Though this is not required, added just in case
          args  = ["serve"]

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
          env {
            name = "VTT_DBUSER"
            value = "${azurerm_postgresql_server.pg_server.administrator_login}@${azurerm_postgresql_server.pg_server.name}"
          }
          env {
            name  = "VTT_DBPASSWORD"
            value = azurerm_postgresql_server.pg_server.administrator_login_password
          }
          env {
            name  = "VTT_DBNAME"
            value = azurerm_postgresql_database.pg_db.name
          }
          env {
            name  = "VTT_DBPORT"
            value = "5432"
          }
          env {
            name  = "VTT_DBHOST"
            value = azurerm_postgresql_server.pg_server.fqdn
          }
          env {
            name  = "VTT_LISTENHOST"
            value = "0.0.0.0"
          }
          env {
            name  = "VTT_LISTENPORT"
            value = var.port
          }
          port {
            container_port = var.port
          }
        }
      }
    }
  }
    depends_on = [
    kubernetes_job.job
  ]
}

# Kubernetes HPA for autoscaling
resource "kubernetes_horizontal_pod_autoscaler" "hpa" {
  metadata {
    name      = "techchallengeapp"
  }

  spec {
    max_replicas = 5
    min_replicas = 2

    target_cpu_utilization_percentage = 70

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "techchallengeapp"
    }
  }
}

# Kubernetes service for the application access
resource "kubernetes_service" "svc" {
  metadata {
    name = "techchallengeapp"
  }
  spec {
    selector = {
      App = kubernetes_deployment.deploy.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = var.port
      target_port = var.port
    }

    type = "LoadBalancer"
  }
}

# Output IP to access the application
output "Application_Access_IP" {
  value = kubernetes_service.svc.status.0.load_balancer.0.ingress.0.ip
}