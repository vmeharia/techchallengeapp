# Configure the Microsoft Azure Provider
provider "azurerm" {

  features {}
}
# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}