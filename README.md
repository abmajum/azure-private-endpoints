# azure-private-endpoints


# Introduction
This repo consists of terraform modules to create private endpoints. The objective of the solution is: Pods in AKS cluster can connect to azure services privately over azure backbone network. This repo would be used in the case we get a private endpoint request from a customer.

# Use

1. Copy an existing module in the pe.tf file
2. Paste it below the first one
3. Rename the new module with the team name so we know which module is for what team.
4. Replace the variables with new variables for the team requesting it.
5. You can run a plan first to make sure it works and builds only what you want to build

## Module Parameters

Info to use module Parameters

| Parameters       | DataType | Options  | Description                                                                |
| ---------------- | -------- | -------- | -------------------------------------------------------------------------- |
| team_name        | string   | Required | The name of the team requesting the private endpoint                       |
| dns_name         | string   | Required | The name of the dns record they want to use to reach their service         |
| dns_zone_name    | string   | Required | This is determined by the resource the private endpoint is connecting to   |
| subresource_name | string   | Required | This is determined by the resource the private endpoint is connecting to   |
| resource_id      | string   | Required | The id of the resource the private endpoint is connecting to               |
| cluster_name     | string   | Required | the name of the cluster they want the private endpoint in (without "-k8s") |
| subscription_id  | string   | Required | The subscription the private endpoint is being deployed to                 |
| environment      | string   | Required | `public` or `china` depending on where you are deploying to                |

# Examples

### Single Cluster

This is a example of one private endpoint created for one cluster:

```
module "dns_zone_amap-teusshared01" {
  source = "../private-dns-zone"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name    = "privatelink.database.windows.net"
  subresource_name = "sqlServer"
  cluster_name     = "amap-teusshared01"
  subscription_id  = var.subscription_ids["amap-teusshared01"]
  environment      = "public"
}

module "abhishek-pe" {
  source = "../private-endpoint"

  team_name = "fake-team"
  dns_name  = "abhishektest"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  # To Find subresource_name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  subresource_name = "sqlServer"
  resource_id      = "/subscriptions/xxxxxx-xxxxxx-xxxxxx-xxxxx/resourceGroups/andrew-test/providers/Microsoft.Sql/servers/abhishek-test"
  cluster_name     = "amap-teusshared01"
  subscription_id  = var.subscription_ids["amap-teusshared01"]
  environment      = "public"
}
```

### Multiple Clusters

#### Multiple Clusters to one Azure Service

This is an example of creating a private endpoint to a single service for multiple clusters:

Make sure dns hosted zone for the particular vnet in which the cluster is already in place. If not , please create it.

First you need to create a variable with all the clusters the customer would like to connect from.

```
variable "<team_name>_clusters" {
  description = "list of clusters <team_name> would like to connect from"
  type        = list(string)
  default     = ["amap-dcusshared01", "amap-npcusshared01", "amap-pcusshared01"]
}
```

Then you call the variable from the instantiation of the module and use it in a for loop.

```

module "abhishek-pe" {
  source = "../private-endpoint"

  for_each  = toset(var.<team_name>_clusters)

  team_name = "fake-team"
  dns_name  = "abhishektest"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  # To Find subresource_name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  subresource_name = "sqlServer"
  resource_id      = "/subscriptions/xxxxxx-xxxxxx-xxxxxx-xxxxx/resourceGroups/andrew-test/providers/Microsoft.Sql/servers/abhishek-test"
  cluster_name     = each.value
  subscription_id  = var.subscription_ids["each.value"]
  environment      = "public"
}
```

### NOTE: 
DNS hosted zone should present per cluster/vnet , before creating the private endpoints
This is a example of one dns hosted zone created for one cluster:

```
module "dns_zone_amap-teusshared01" {
  source = "../private-dns-zone"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name    = "privatelink.database.windows.net"
  subresource_name = "sqlServer"
  cluster_name     = "amap-teusshared01"
  subscription_id  = var.subscription_ids["amap-teusshared01"]
  environment      = "public"
}
```
Clone the Repo and create the dns hosted zone first

```
terraform apply -target=module.dns_zone_amap-teusshared01
```

### Clean UP Customer Private Endpoints 
Do not destroy all the resources at once, and do not destroy the dns hosted zone.
Only destroy private endpoint related to customers.
```
terraform destroy -target=module.<team-name>-<clustername>-<resourcename>