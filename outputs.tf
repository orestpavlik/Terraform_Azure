output "ipaddres" {
  value = azurerm_linux_virtual_machine.VM-1.public_ip_address
  sensitive = true
}