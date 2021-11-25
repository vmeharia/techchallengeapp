# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_prefix]
}

# Create subnet on virtual network
resource "azurerm_subnet" "snet" {
  name                 = var.subnet_names
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet_prefix]
}

# Create virtual network rule for postgres
resource "azurerm_postgresql_virtual_network_rule" "pg_vnet_rule" {
  name                                 = "pg-vnet-rule"
  resource_group_name                  = azurerm_resource_group.rg.name
  server_name                          = azurerm_postgresql_server.pg_server.name
  subnet_id                            = azurerm_subnet.snet.id
  ignore_missing_vnet_service_endpoint = true
}