# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "iotresourcegroup" {
  name     = "__var.resourcegroupname__"
  location = "__var.resourcegrouplocation__"
}
#refer to a subnet
data "azurerm_subnet" "mynetwork" {
  name                 = "__var.azurerm_subnet_name__"
  virtual_network_name = "__var.azurerm_virtual_network_name__"
  resource_group_name  = "__var.azurerm_resourcegroupname__"
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
  name                = "__var.resourcenetworkinterface__"
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
  name                     = "__var.resourcestoragenamevm__"
  resource_group_name      = azurerm_resource_group.iotresourcegroup.name
  location                 = azurerm_resource_group.iotresourcegroup.location
  account_tier             = "__var.resourcestoragenameaccount_tier__"
  account_replication_type = "__var.resourcestorgageaccountreplication__"

}
/*data "azurerm_storage_account" "mystorageaccount" {
  name                = "__var.resourcestoragename__"
  resource_group_name = "azurerm_resource_group.iotresourcegroup.name"
}*/
# Create (and display) an SSH key
resource "tls_private_key" "epm_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { value = tls_private_key.epm_ssh.private_key_pem }

resource "azurerm_linux_virtual_machine" "myvm" {
  name                = "__var.resourcevmname__"
  resource_group_name = azurerm_resource_group.iotresourcegroup.name
  location            = azurerm_resource_group.iotresourcegroup.location
  size                = "__var.reourcevmsize__"
  admin_username      = "__var.resourcevmadminuser__"
  network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]

  admin_ssh_key {
    username   = "__var.resourcevmadminuser__"
    #public_key = file("~/.ssh/id_rsa.pub")
    public_key     = tls_private_key.epm_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "__var.resourcevmpublisher__"
    offer     = "__var.resourcevmoffer__"
    sku       = "7.5"
    version   = "latest"
  }

  boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

  tags {​​
    "Fecha de Creacion en la Nube" = "__var.creation__"
    "Contacto_Infraestructura" = "__var.contact__"
    "Contacto_Solucion" = "__var.contactSolution__"
    "Servicio-Aplicacion" = "__var.app__"
    "Descripcion" = "__var.description__"
 }​​
}