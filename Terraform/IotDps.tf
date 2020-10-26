resource "azurerm_resource_group" "example" {
  name     = "__resourcegroupname__"
  location = "__resourcegrouplocation__"
}

resource "azurerm_iothub_dps" "example" {
  name                = "__resourceiotdps__"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sku {
    name     = "__resourceiotdpsskuname__"
    capacity = "__resourceiotdpsskucapacity__"
  }
}

# IOT Device provisioning Service Certificate
/*resource "azurerm_iothub_dps_certificate" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  iot_dps_name        = azurerm_iothub_dps.example.name

  certificate_content = filebase64("example.cer")
}*/

# Device Provisioning Service Shared Access policy
/*resource "azurerm_iothub_dps_shared_access_policy" "example" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example.name
  iothub_dps_name     = azurerm_iothub_dps.example.name

  enrollment_write = true
  enrollment_read  = true
}*/