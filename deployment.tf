provider "kubernetes" {
  host = azurerm_kubernetes_cluster.aks.kube_config.0.host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}
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
          args  = ["updatedb", "-s", "serve"]

          env {
            name = "VTT_DBUSER"
            # Database users must be in the username@host format, for Azure-based PostgreSQL servers.
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
            value = "80"
          }
          port {
            container_port = 80
          }
        }
      }
    }
  }
}