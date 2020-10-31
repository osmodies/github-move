terraform {  
backend "azurerm" {
    storage_account_name = "__var.terraformstorageaccount__"
    container_name       = "__var.terraformContainername__"
    key                  = "__var.terraformstoragekey__"
    access_key  ="__terrafconnectionstring__"
  }
}
data "azurerm_resource_group" "resourcegropuiothub" {
  name     = "__var.resourcegroupname__"
}

resource "azurerm_iothub" "myitohub" {
  name                = "__var.resourceiothubname__"
  resource_group_name = data.azurerm_resource_group.resourcegropuiothub.name
  location            = data.azurerm_resource_group.resourcegropuiothub.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  tags = {
          "Fecha de Creacion en la Nube" = "__var.tagcreation__"
          "Contacto_Infraestructura" = "__var.tagcontactinfraestructure__"
          "Contacto_Solucion" = "__var.tagcontactSolution__"
          "Servicio-Aplicacion" = "__var.tagapp__"
          "Descripcion" = "__var.tagdescription__"
      }
}