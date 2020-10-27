# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "iotresourcegroup" {
  name     = "__resourcegroupname__"
  location = "__resourcegrouplocation__"
}
#refer to a subnet
data "azurerm_subnet" "mynetwork" {
  name                 = "__azurerm_subnet_name__"
  virtual_network_name = "__azurerm_virtual_network_name__"
  resource_group_name  = "__azurerm_resourcegroupname__"
}

/*resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.iotresourcegroup.location
  resource_group_name = azurerm_resource_group.iotresourcegroup.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.iotresourcegroup.name
  virtual_network_name = azurerm_virtual_network.iotresourcegroup.name
  address_prefixes     = ["10.0.2.0/24"]
}*/

resource "azurerm_network_interface" "mynetworkinterface" {
  name                = "__resourcenetworkinterface__"
  location            = azurerm_resource_group.iotresourcegroup.location
  resource_group_name = azurerm_resource_group.iotresourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.mynetwork.id
    private_ip_address_allocation = "Dynamic"
  }
}
#Storage account
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "__resourcestoragename__"
  resource_group_name      = azurerm_resource_group.iotresourcegroup.name
  location                 = azurerm_resource_group.iotresourcegroup.location
  account_tier             = "__resourcestoragenameaccount_tier__"
  account_replication_type = "__resourcestorgageaccountreplication__"

}
resource "azurerm_linux_virtual_machine" "myvm" {
  name                = "__resourcevmname__"
  resource_group_name = azurerm_resource_group.iotresourcegroup.name
  location            = azurerm_resource_group.iotresourcegroup.location
  size                = "__reourcevmsize__"
  admin_username      = "__resourcevmadminuser__"
  network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]

  admin_ssh_key {
    username   = "__resourcevmadminuser__"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "__resourcevmpublisher__"
    offer     = "__resourcevmoffer__"
    sku       = "7.5"
    version   = "latest"
  }

  boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }
}