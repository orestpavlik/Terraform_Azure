resource "azurerm_resource_group" "arg" {
  name     = "Teraform_Test"
  location = "West Europe"
}

resource "azurerm_virtual_network" "main" {
  name                = "QA-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "QA-nic"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

}
resource "azurerm_ssh_public_key" "pub_key" {
  name                = "Key_for_vm"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  public_key          = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.ansg_1.id
}
resource "azurerm_linux_virtual_machine" "VM-1" {
  name                = "VM1-machine"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  size                = "Standard_DS1_v2"
  admin_username      = "var.vmAdminUsername"
  network_interface_ids = [azurerm_network_interface.main.id]

  admin_ssh_key {
    username   = "var.vmAdminUsername"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}