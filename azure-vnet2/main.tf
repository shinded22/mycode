# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

variable "name" {
    type        = string
    default     = "testy"
    description = "Name for this infrastructure"
}

variable "location" {
    type         = string
    description  = "Name of the region for this infrastructure"
    default      = "westus2"
}

variable "address_space" {
    type        = string
    description = "Cidr range for the Virtual Network"
    default     = "10.10.0.0/16"    # range from 10.10.0.1 to 10.10.255.254
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-Group"      // example -> "myTFResourceGroup"
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "this" {
  name                = var.name
  address_space       = [var.address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnets
resource "azurerm_subnet" "public" {
  name                 = "${var.name}-public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 1)]
}

resource "azurerm_subnet" "private" {
  name                 = "${var.name}-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 10)]
}    

