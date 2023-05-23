terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.82.0" 
    }
  }
}

provider "azurerm" {
    version = "2.82.0"

    features {}
}
