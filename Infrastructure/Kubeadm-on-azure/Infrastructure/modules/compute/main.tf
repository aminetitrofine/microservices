#Create virtual machine
resource "azurerm_linux_virtual_machine" "virtualmachine" {
  name                       = var.vmname
  location                   = var.location
  resource_group_name        = var.resourcegroup
  network_interface_ids      = var.nic
  size                       = var.vmsize # "Standard_ D2S_v3"
  admin_username             = var.admin_username
  allow_extension_operations = false

  source_image_reference {
    publisher = "debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.publickey 
  }

  tags = {
    environment = "dev"
  }


}



