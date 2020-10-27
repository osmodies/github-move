resource "azurerm_resource_group" "resourcegroup" {
  name     = "__resourcegroupname__"
  location = "__resourcegrouplocation__"
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "__storageaccountname__"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "__account_tier__"
  account_replication_type = "__account_replication_type__"

}