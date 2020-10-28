resource "azurerm_resource_group" "resourcegroupiotdps" {
  name     = __var.resourcegroupname__"
  location = __var.resourcegrouplocation__"
}

resource "azurerm_iothub_dps" "iotdps" {
  name                = __var.resourceiotdps__"
  resource_group_name = azurerm_resource_group.resourcegroupiotdps.name
  location            = azurerm_resource_group.resourcegroupiotdps.location

  sku {
    name     = __var.resourceiotdpsskuname__"
    capacity = __var.resourceiotdpsskucapacity__"
  }
    
  tags = {​​
    Fecha_de_Creacion_en_la_Nube = "__var.creation__"
    Contacto_Infraestructura = "__var.contact__"
    Contacto_Solucion = "__var.contactSolution__"
    Servicio-Aplicacion = "__var.app__"
    Descripcion = "__var.description__"
 }
}

# IOT Device provisioning Service Certificate
/*resource "azurerm_iothub_dps_certificate" "dpscertificate" {
  name                = "example"
  resource_group_name = azurerm_resource_group.resourcegroupiotdps.name
  iot_dps_name        = azurerm_iothub_dps.iotdps.name

  certificate_content = filebase64("example.cer")
}*/

# Device Provisioning Service Shared Access policy
/*resource "azurerm_iothub_dps_shared_access_policy" "dpsaccesspolicy" {
  name                = "example"
  resource_group_name = azurerm_resource_group.resourcegroupiotdps.name
  iothub_dps_name     = azurerm_iothub_dps.iotdps.name

  enrollment_write = true
  enrollment_read  = true
}*/