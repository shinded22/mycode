# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "dsGroup"
  location = "westus2"
}

module "vnet" {
    source = "Azure/vnet/azurerm"
    version = "4.1.0"
    resource_group_name = azurerm_resource_group.rg.name
    use_for_each = false
    vnet_location = azurerm_resource_group.rg.location
}
