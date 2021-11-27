# Configure the Microsoft Azure Provider
provider "azurerm" {

  features {
  #  subscription_id = ""
  }
}

# Configure Kubernetes Provider
provider "kubernetes" {
  host = azurerm_kubernetes_cluster.aks.kube_config.0.host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}