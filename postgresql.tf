resource "azurerm_postgresql_server" "pg_server" {
  name                          = "test-pgserver"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  administrator_login           = var.pgserver_username
  administrator_login_password  = var.pgserver_password
  sku_name                      = "GP_Gen5_4"
  version                       = "11"
  storage_mb                    = 640000
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = true
  auto_grow_enabled             = true
  public_network_access_enabled = true
  ssl_enforcement_enabled       = false
}

resource "azurerm_postgresql_database" "pg_db" {
  name                = "test-pgdb"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.pg_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}