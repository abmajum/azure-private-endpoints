terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.38.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "Terraform"
    storage_account_name = "scpterraformstate"
    container_name       = "tfstate"
    subscription_id      = "XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX"
    key                  = "private-endpoints"
  }
}
# ------------------------------------------------------ Create DNS hosted zone per cluster/vnet -------------------------------------------------#

module "dns_zone_ece-dweushared01" {
  source = "../private-dns-zone"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name    = "privatelink.database.windows.net"
  subresource_name = "sqlServer"
  cluster_name     = "ece-dweushared01"
  subscription_id  = var.subscription_ids["ece-dweushared01"]
  environment      = "public"
}

module "dns_zone_ece-dneushared01" {
  source = "../private-dns-zone"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name    = "privatelink.database.windows.net"
  subresource_name = "sqlServer"
  cluster_name     = "ece-dneushared01"
  subscription_id  = var.subscription_ids["ece-dneushared01"]
  environment      = "public"
}
# ---------------------------------------------------------- Create Private Endpoints ------------------------------------------------------------#

module "dgtkey-ece-dweushared01-ece-devweub" { # emea dev primary to Primary database
  source = "../private-endpoint"

  team_name = "digital-key-core"
  dns_name  = "ece-devweub-dgtkey-dkc-sql.database.windows.net"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  # To Find subresource_name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  subresource_name = "sqlServer"
  resource_id      = "/subscriptions/XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX/resourceGroups/ece-devweub-dgtkey-dkc-rg/providers/Microsoft.Sql/servers/ece-devweub-dgtkey-dkc-sql"
  cluster_name     = "ece-dweushared01"
  subscription_id  = var.subscription_ids["ece-dweushared01"]
  environment      = "public"
}


module "dgtkey-ece-dneushared01-ece-devneub" { # emea dev secondary to Secondary database
  source = "../private-endpoint"

  team_name = "digital-key-core"
  dns_name  = "ece-devneub-dgtkey-dkc-sql.database.windows.net"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  # To Find subresource_name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  subresource_name = "sqlServer"
  resource_id      = "/subscriptions/XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX/resourceGroups/ece-devneub-dgtkey-dkc-rg/providers/Microsoft.Sql/servers/ece-devneub-dgtkey-dkc-sql"
  cluster_name     = "ece-dneushared01"
  subscription_id  = var.subscription_ids["ece-dneushared01"]
  environment      = "public"
}



module "dgtkey-ece-dweushared01-ece-devneub" { # emea dev primary to Secondary database
  source = "../private-endpoint"

  team_name = "digital-key-core"
  dns_name  = "ece-devneub-dgtkey-dkc-sql.database.windows.net"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  # To Find subresource_name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  subresource_name = "sqlServer"
  resource_id      = "/subscriptions/XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX/resourceGroups/ece-devneub-dgtkey-dkc-rg/providers/Microsoft.Sql/servers/ece-devneub-dgtkey-dkc-sql"
  cluster_name     = "ece-dweushared01"
  subscription_id  = var.subscription_ids["ece-dweushared01"]
  environment      = "public"
}

module "dgtkey-ece-dneushared01-ece-devweub" { # emea dev secondary to Primary database
  source = "../private-endpoint"

  team_name = "digital-key-core"
  dns_name  = "ece-devweub-dgtkey-dkc-sql.database.windows.net"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  # To Find subresource_name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  subresource_name = "sqlServer"
  resource_id      = "/subscriptions/XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX/resourceGroups/ece-devweub-dgtkey-dkc-rg/providers/Microsoft.Sql/servers/ece-devweub-dgtkey-dkc-sql"
  cluster_name     = "ece-dneushared01"
  subscription_id  = var.subscription_ids["ece-dneushared01"]
  environment      = "public"
}

# NOTE: See README for examples
