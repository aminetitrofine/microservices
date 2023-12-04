resource "azurerm_resource_group" "data" {
  name     = var.resource_group_name
  location = var.location
}

#Create VNET with Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.data.location
  resource_group_name = azurerm_resource_group.data.name
  address_space       = ["172.10.0.0/16"]

  tags = {
    environment = "dev"
  }
}

#Create subnet within VNET
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.data.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.10.1.0/24"]
}




