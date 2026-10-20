terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Target deployment environment"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "Azure region for Finland workloads"
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "PlatformEngineering"
    Compliance  = "FinancialSectorGovernance"
  }
}

resource "azurerm_resource_group" "platform_rg" {
  name     = "rg-cloud-platform-${var.environment}-ne"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_container_registry" "acr" {
  name                = "acrcloudplatformfinland01"
  resource_group_name = azurerm_resource_group.platform_rg.name
  location            = azurerm_resource_group.platform_rg.location
  sku                 = "Premium"
  admin_enabled       = false
  tags                = local.common_tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "aks-cloud-platform-${var.environment}"
  location                  = azurerm_resource_group.platform_rg.location
  resource_group_name       = azurerm_resource_group.platform_rg.name
  dns_prefix                = "aks-platform"
  automatic_channel_upgrade = "patch"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name       = "systempool"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  tags = local.common_tags
}
