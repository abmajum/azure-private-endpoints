### Use case of creating a dns hosted zone per cluster per vnet 

```
module "dns_zone_amap_teusshared01" {                 
  source = "../../pipeline-lib/terraform/azure/private-dns-zone"

  # To find DNS Zone Name: https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  dns_zone_name = "privatelink.database.windows.net"
  subresource_name = "sqlServer"
  cluster_name     = "amap-teusshared01"
  subscription_id  = var.subscription_ids["amap-teusshared01"]
  environment      = "public"
}
```
## Module Parameters

Info to use module Parameters

| Parameters       | DataType | Options  | Description                                                                |
| ---------------- | -------- | -------- | -------------------------------------------------------------------------- |
| dns_zone_name    | string   | Required | This is determined by the resource the private endpoint is connecting to   |
| subresource_name | string   | Required | This is determined by the resource the private endpoint is connecting to   |
| cluster_name     | string   | Required | the name of the cluster they want the private endpoint in (without "-k8s") |
| subscription_id  | string   | Required | The subscription the private endpoint is being deployed to                 |
| environment      | string   | Required | public or china depending on where you are deploying to                    |
