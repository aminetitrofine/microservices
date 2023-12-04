

#Create Public IP
resource "azurerm_public_ip" "publicip" {
  for_each            = toset(var.vmname)
  name                = join("-nic", [each.value])
  location            = var.location
  resource_group_name = var.resourcegroup
  allocation_method   = "Static"
  domain_name_label   = join("-node", [each.value])
  tags = {
    environment = "dev"
  }
}

#Create network interface card 
resource "azurerm_network_interface" "network_interface" {
  for_each            = toset(var.vmname)
  name                = join("-nic", [each.value])
  location            = var.location
  resource_group_name = var.resourcegroup

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[each.key].id #azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "devops-nsg"
  location            = var.location
  resource_group_name = var.resourcegroup


  security_rule {
    name                       = "Allow_SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" #"129.185.112.26"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_Kubernetes_API"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_Node_Communication"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30000-32767"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow_NFS_TO_DATA-VM_Inbound"
    priority                   = 330
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2049"
    source_address_prefix      = "172.10.1.0/24"
    destination_address_prefix = "172.10.1.0/24"
  }
  security_rule {
    name                       = "Allow_8080_Inbound"
    priority                   = 340
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow_HTTP_Inbound"
    priority                   = 350
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow_HTTPS_Inbound"
    priority                   = 360
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow_Internet_Outbound"
    priority                   = 400
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
  security_rule {
    name                       = "Allow_NFS_TO_DATA-VM_Outbound"
    priority                   = 410
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2049"
    source_address_prefix      = "172.10.1.0/24"
    destination_address_prefix = "172.10.1.0/24"
  }

}
resource "azurerm_subnet_network_security_group_association" "subnet-nsg_association" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "nic-nsg_association" {
  for_each                  = toset(var.vmname)
  network_interface_id      = azurerm_network_interface.network_interface[each.value].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}