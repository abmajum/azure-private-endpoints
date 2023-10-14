terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.38.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  environment     = var.environment
}

data "azurerm_resource_group" "network_rg" {
  name = "${var.cluster_name}-fundamental-rg"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.cluster_name}-vnet"
  resource_group_name = data.azurerm_resource_group.network_rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = "${var.cluster_name}-svc"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.network_rg.name
}

resource "azurerm_resource_group" "pe_dns" {
  name     = "customer-private-endpoint-dns"
  location = data.azurerm_resource_group.network_rg.location
}

resource "azurerm_private_dns_zone" "pe-dns-zone" {
  # https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.pe_dns.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pe-dns-link" {
  name                  = "${var.subresource_name}-dns-link"
  resource_group_name   = azurerm_resource_group.pe_dns.name
  private_dns_zone_name = azurerm_private_dns_zone.pe-dns-zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}