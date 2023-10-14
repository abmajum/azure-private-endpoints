### Use case of aci-with-vnet azure module 

```
module "abhishek-pe" {
  source = "./private-endpoint"

  team_name = "fake-team"
  dns_name  = "abhishektest"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  # To Find subresource_name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  subresource_name = "sqlServer"
  resource_id      = "<resource_id"
  cluster_name     = "amap-teusshared01"
  subscription_id  = var.subscription_ids["amap-teusshared01"]
  environment      = "public"
}
```
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
| environment      | string   | Required | public or china depending on where you are deploying to                    |
