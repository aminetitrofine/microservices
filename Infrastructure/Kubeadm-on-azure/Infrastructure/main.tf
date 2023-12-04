module "compute-data" {
  source = "./modules/data"
  vmname = var.vmname-data
  vmsize = "Standard_B2s"

}


module "general" {
  source = "./modules/general"

}


module "network" {
  source        = "./modules/network"
  vmname        = local.vmnames
  prefix        = var.prefix
  location      = module.general.resource_group_location
  resourcegroup = module.general.resource_group_name
  subnet_id     = module.compute-data.azurerm_subnet_id
  depends_on    = [module.general, module.compute-data]

}



module "compute" {
  source           = "./modules/compute"
  for_each         = toset(local.vmnames)
  vmname           = each.value
  resourcegroup    = module.general.resource_group_name
  location         = module.general.resource_group_location
  nic              = [module.network.network_interface[each.key].id]
  publickey        = file(var.publickey-path)
  vmsize           = each.value == "dto-master-1" ? "Standard_D2s_v3" : "Standard_D2s_v3" # "Standard_D2S_v3"
  public_ip        = [module.network.publicip[each.key].fqdn]
  private_key_path = "./../.ssh/id_rsa"
  depends_on       = [module.network.azurerm_network_interface, module.general]
}
