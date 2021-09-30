resource "azurerm_storage_account" "Bucker" {
  name                     = "one"
  resource_group_name      = azurerm_resource_group.arg.name
  location                 = azurerm_resource_group.arg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.internal.id]
  }
}