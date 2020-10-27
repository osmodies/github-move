resource "azurerm_resource_group" "example" {
  name     = "__resourcegroupname__"
  location = "__resourcegrouplocation__"
}

resource "azurerm_storage_account" "example" {
  name                     = "__resourcestoragename__"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "__reourcestorageaccounttier__"
  account_replication_type = "__resourcestorgageaccountreplication__"
}

resource "azurerm_storage_container" "example" {
  name                  = "__resourcestoragecontainername__"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "__resourcesstoragecontaineraccess__"
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "__resourceeventhubnamepace__"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "__resourceeventhubnamespacesku__"
}

resource "azurerm_eventhub" "example" {
  name                = "__resourceeventhubname__"
  resource_group_name = azurerm_resource_group.example.name
  namespace_name      = azurerm_eventhub_namespace.example.name
  partition_count     = __resourceeventhubpartitioncount__
  message_retention   = __resourceeventhubmessageretention__
}

resource "azurerm_eventhub_authorization_rule" "example" {
  resource_group_name = azurerm_resource_group.example.name
  namespace_name      = azurerm_eventhub_namespace.example.name
  eventhub_name       = azurerm_eventhub.example.name
  name                = "__resourceauthorizationrulename__"
  send                = __resourceauthorizationrulesend__
}

resource "azurerm_iothub" "example" {
  name                = "__resourceiothubname__"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = azurerm_storage_account.example.primary_blob_connection_string
    name                       = "__routeendpoint__"
    batch_frequency_in_seconds = __endpointbatchfrecuency__
    max_chunk_size_in_bytes    = __endpointmaxchunksize__
    container_name             = azurerm_storage_container.example.name
    encoding                   = "__endpointencoding__"
    file_name_format           = "__endpointfilenameformat__"
  }

  endpoint {
    type              = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.example.primary_connection_string
    name              = "__routeendpoint2__"
  }

  route {
    name           = "__routename__"
    source         = "__routesource__"
    condition      = "__routecondition__"
    endpoint_names = ["__routeendpoint__"]
    enabled        = __routeenabled__
  }

  route {
    name           = "__routename2__"
    source         = "__routesource2__"
    condition      = "__routecondition2__"
    endpoint_names = ["__routeendpoint2__"]
    enabled        = __routeenabled2__
  }

  tags = {
    purpose = "testing"
  }
}