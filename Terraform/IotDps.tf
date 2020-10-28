resource "azurerm_resource_group" "resourcegroupiotdps" {
  name     = __varvar.resourcegroupname__"
  location = __varvar.resourcegrouplocation__"
}

resource "azurerm_iothub_dps" "iotdps" {
  name                = __varresourceiotdps__"
  resource_group_name = azurerm_resource_group.resourcegroupiotdps.name
  location            = azurerm_resource_group.resourcegroupiotdps.location

  sku {
    name     = __varresourceiotdpsskuname__"
    capacity = __varresourceiotdpsskucapacity__"
  }
 }​​
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