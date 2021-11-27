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
          image   = "servian/techchallengeapp:latest"
          name    = "techchallengeapp"
          command = ["./TechChallengeApp"]
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

  spec {
    replicas = 2
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
          image   = "servian/techchallengeapp:latest"
          name    = "techchallengeapp"
          command = ["./TechChallengeApp"]
          args  = ["serve"]

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