resource "azurerm_resource_group" "resourcegropuiothub" {
  name     = "__var.resourcegroupname__"
  location = "__var.resourcegrouplocation__"
}


/*resource "azurerm_storage_account" "mystorage" {
  name                     = "__var.resourcestoragename__"
  resource_group_name      = azurerm_resource_group.resourcegropuiothub.name
  location                 = azurerm_resource_group.resourcegropuiothub.location
  account_tier             = "__var.reourcestorageaccounttier__"
  account_replication_type = "__var.resourcestorgageaccountreplication__"
}

resource "azurerm_storage_container" "mystoragecontainer" {
  name                  = "__var.resourcestoragecontainername__"
  storage_account_name  = azurerm_storage_account.mystorage.name
  container_access_type = "__var.resourcesstoragecontaineraccess__"
}*/

resource "azurerm_eventhub_namespace" "myeventhubnamespace" {
  name                = "__var.resourceeventhubnamepace__"
  resource_group_name = azurerm_resource_group.resourcegropuiothub.name
  location            = azurerm_resource_group.resourcegropuiothub.location
  sku                 = "__var.resourceeventhubnamespacesku__"
}

resource "azurerm_eventhub" "myeventhub" {
  name                = "__var.resourceeventhubname__"
  resource_group_name = azurerm_resource_group.resourcegropuiothub.name
  namespace_name      = azurerm_eventhub_namespace.myeventhubnamespace.name
  partition_count     = __var.resourceeventhubpartitioncount__
  message_retention   = __var.resourceeventhubmessageretention__
}

resource "azurerm_eventhub_authorization_rule" "eventhubautorization" {
  resource_group_name = azurerm_resource_group.resourcegropuiothub.name
  namespace_name      = azurerm_eventhub_namespace.myeventhubnamespace.name
  eventhub_name       = azurerm_eventhub.myeventhub.name
  name                = "__var.resourceauthorizationrulename__"
  send                = __var.resourceauthorizationrulesend__
}

resource "azurerm_iothub" "myitohub" {
  name                = "__var.resourceiothubname__"
  resource_group_name = azurerm_resource_group.resourcegropuiothub.name
  location            = azurerm_resource_group.resourcegropuiothub.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    #connection_string          = "__terrafconnectionstring__"
    name                       = "__var.routeendpoint__"
    batch_frequency_in_seconds = __var.endpointbatchfrecuency__
    max_chunk_size_in_bytes    = __var.endpointmaxchunksize__
    #container_name             = "__var.containernameiot__"
    encoding                   = "__var.endpointencoding__"
    file_name_format           = "__var.endpointfilenameformat__"
  }

  endpoint {
    type              = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.eventhubautorization.primary_connection_string
    name              = "__var.routeendpoint2__"
  }

  route {
    name           = "__var.routename__"
    source         = "__var.routesource__"
    condition      = "__var.routecondition__"
    endpoint_names = ["__var.routeendpoint__"]
    enabled        = __var.routeenabled__
  }

  route {
    name           = "__var.routename2__"
    source         = "__var.routesource2__"
    condition      = "__var.routecondition2__"
    endpoint_names = ["__var.routeendpoint2__"]
    enabled        = __var.routeenabled2__
  }

  tags = {​​

    "Fecha de Creacion en la Nube" = "__var.var.creation__"
    "Contacto_Infraestructura" = "__var.var.contact__"
    "Contacto_Solucion" = "__var.var.contactSolution__"
    "Servicio-Aplicacion" = "__var.var.app__"
    "Descripcion" = "__var.var.description__"
 }​​
  
}