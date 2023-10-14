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

locals {
  db_name = element(split("/", var.resource_id), length(split("/", var.resource_id)) - 1)
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

resource "azurerm_resource_group" "pe_rg" {
  name     = "${var.cluster_name}-private-endpoint-rg-${var.team_name}-${local.db_name}"
  location = data.azurerm_resource_group.network_rg.location
}

resource "azurerm_private_dns_a_record" "dns_a" {
  name                = format("%s-%s", var.dns_name, "arecord")
  zone_name           = var.dns_zone_name
  resource_group_name = "customer-private-endpoint-dns"
  ttl                 = 300
  records             = [azurerm_private_endpoint.pe.private_service_connection.0.private_ip_address]
}



data "azurerm_private_dns_zone" "dns_zone_id" {
  name                = var.dns_zone_name
  resource_group_name = "customer-private-endpoint-dns"
}


# Separate Subscription Example
# You would use this block if the SQL server and the client resource you are connecting to it are NOT in the same subscription
resource "azurerm_private_endpoint" "pe" {
  name                = "${var.team_name}-private-endpoint-${var.subresource_name}"
  resource_group_name = azurerm_resource_group.pe_rg.name
  location            = azurerm_resource_group.pe_rg.location
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                 = "${var.team_name}-private-endpoint-svc-connection"
    is_manual_connection = true
    request_message      = "This is a private endpoint request from SCP for ${var.team_name}"
    # You can get the resource id by looking at the properties section of the resource in the Azure Portal
    private_connection_resource_id = var.resource_id
    # https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
    subresource_names = ["${var.subresource_name}"]
  }

  private_dns_zone_group {
    name                 = "${var.subresource_name}-${var.team_name}"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.dns_zone_id.id]
  }

}

output "dns_a_record" {
  value = azurerm_private_dns_a_record.dns_a.fqdn
}

output "private_ip" {
  value = azurerm_private_endpoint.pe.private_service_connection.0.private_ip_address
}