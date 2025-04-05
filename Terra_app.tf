terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Declare the required variables
variable "client_id" {
  description = "The Client ID for Azure authentication"
  type        = string
}

variable "client_secret" {
  description = "The Client Secret for Azure authentication"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Tenant ID for Azure authentication"
  type        = string
}

variable "subscription_id" {
  description = "The Subscription ID for Azure"
  type        = string
}

# Configure the Azure provider
provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "appservice-resource-group"
  location = "East US"
}

# Create an App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = "webapijenkinsrani_plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create an App Service
resource "azurerm_app_service" "example" {
  name                = "webapijenkinsrani"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    always_on = true
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}
