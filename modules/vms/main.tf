resource "azurerm_virtual_machine" "VM" {
  name                  = "${var.name}"
  location              = "${var.location}"
  resource_group_name   = "${var.rg}"
  network_interface_ids = ["${azurerm_network_interface.NIC.id}"]
  vm_size               = "Standard_A1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${azurerm_virtual_machine.VM.name}-disk-OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "demo-instance"
    admin_username = "demo"
    #admin_password = "..."
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("mykey.pub")
      path     = "/home/demo/.ssh/authorized_keys"
    }
  }

}

resource "azurerm_network_interface" "NIC" {
  name                      = "${var.name}-nic1"
  location                  = "${var.location}"
  resource_group_name       = "${var.rg}"
  #network_security_group_id = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_public_ip" "publicip" {
  name                = "${var.name}-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.rg}"
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network" "VNET" {
  name                = "${var.name}-network"
  location            = "${var.location}"
  resource_group_name = "${var.rg}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.name}-subnet1"
  resource_group_name  = "${var.rg}"
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefix       = "10.0.0.0/24"
  network_security_group_id = azurerm_network_security_group.sg-ssh.id
}

resource "azurerm_network_security_group" "sg-ssh" {
  name                = "${var.name}-sg-ssh"
  location            = "${var.location}"
  resource_group_name = "${var.rg}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}