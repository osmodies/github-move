# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

data "azurerm_resource_group" "iotresourcegroup" {
  name     = "__var.resourcegroupname__"
}
#refer to a subnet
data "azurerm_subnet" "mynetwork" {
  name                 = "__var.azurerm_subnet_name__"
  virtual_network_name = "__var.azurerm_virtual_network_name__"
  resource_group_name  = "__var.azurerm_resourcegroupname__"
}

resource "azurerm_network_interface" "mynetworkinterface" {
  name                = "__var.resourcenetworkinterface__"
  location            = data.azurerm_resource_group.iotresourcegroup.location
  resource_group_name = data.azurerm_resource_group.iotresourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.mynetwork.id
    private_ip_address_allocation = "Dynamic"
  }
}
#Storage account
data "azurerm_storage_account" "storagebootdiagnostics" {
  name                = "__var.resourcevmstoragename__"
  resource_group_name = "__var.resourcevmstorageresourcegroup__"
}

#Get  keyvault 
data "azurerm_key_vault" "epmkeyvault" {
  name                = "__var.keyvaultname__"
  resource_group_name = "__var.keyvaultresourcegroup__"
}

#Get secret keyvault 
data "azurerm_key_vault_secret" "keyvaultsecret" {
  name         = "__var.keyvaultsecretnamepublic__"
  key_vault_id = data.azurerm_key_vault.epmkeyvault.id
}

# get azurerm_availability_set
data "azurerm_availability_set" "avsetvm" {
  name                = "__var.resourcevmavsetname__"
  resource_group_name = "__var.resourcevmavsetnameresourcegroup__"
}

resource "azurerm_linux_virtual_machine" "myvm" {
  name                = "__var.resourcevmname__"
  resource_group_name = data.azurerm_resource_group.iotresourcegroup.name
  location            = data.azurerm_resource_group.iotresourcegroup.location
  size                = "__var.resourcevmsize__"
  admin_username      = "__var.resourcevmadminuser__"
  #admin_password      = "__var.resourcevmadminpassword__"
  #availability_set_id             = data.azurerm_availability_set.avsetvm.id
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]

  admin_ssh_key {
    username   = "__var.resourcevmadminuser__"
    #public_key = file("__System.DefaultWorkingDirectory__/__var.keyvaultsecretfilepublic__")
    public_key  = data.azurerm_key_vault_secret.keyvaultsecret.value
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
        storage_account_uri = data.azurerm_storage_account.storagebootdiagnostics.primary_blob_endpoint
    }

  tags = {
          "Fecha de Creacion en la Nube" = formatdate("MM/DD/YYYY hh:mm:ss", timestamp())
          "Contacto_Infraestructura" = "__var.tagcontactinfraestructure__"
          "Contacto_Solucion" = "__var.tagcontactSolution__"
          "Servicio-Aplicacion" = "__var.tagapp__"
          "Descripcion" = "__var.tagdescription__"
      }
}