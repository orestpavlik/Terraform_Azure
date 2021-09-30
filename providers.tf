# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.46.0"
    }
  }
    backend "azurerm" {
        resource_group_name  = "For_tets_terraform"
        storage_account_name = "tfstate1221"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}