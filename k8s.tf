# Create an Azure Kubernetes Service (AKS) cluster with default node pool
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = "1.21.2"
  dns_prefix          = var.dns_prefix_name
  node_resource_group = var.node_resource_group

  role_based_access_control {
    enabled = true
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = "standard"
    dns_service_ip     = var.service_ip
    docker_bridge_cidr = var.docker_cidr
    service_cidr       = var.service_cidr
  }
  default_node_pool {
    name           = "pool1"
    node_count     = "1"
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.snet.id
  }
}