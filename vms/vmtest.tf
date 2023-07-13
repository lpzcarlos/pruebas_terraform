module "vmtest" {
  source                   = "../modules/vms"
  resource_group           = "${var.rg}"
  location                 = "${var.location}"
  vm_name                  = "vmtest"
}