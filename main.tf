provider "azuread" {
  version = "~> 0.8.0"
}

provider "random" {
  version = "~> 2.2"
}

provider "local" {
  version = "~> 1.4"
}

provider "azurerm" {
  version = "~> 2.9"
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "state" {
  name = var.resource_group_name
}

resource "azurerm_management_lock" "terraform-resource-group" {
  name       = "terraform"
  scope      = data.azurerm_resource_group.state.id
  lock_level = "CanNotDelete"
  notes      = "Protects the terraform state files and key vault."
}

locals {
  location = coalesce(var.location, data.azurerm_resource_group.state.location)
  tags     = merge(data.azurerm_resource_group.state.tags, var.tags)
}
