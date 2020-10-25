resource "azurerm_resource_group" "StorageAccount" {
  name     = "__resourcegrouprname__"
  location = "East US"
}

resource "azurerm_storage_account" "StorageAccount" {
  name                     = "__storageaccountname__"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "__account_tier__"
  account_replication_type = "__account_replication_type__"

}