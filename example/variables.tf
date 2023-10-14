variable "subscription_ids" {
  type        = map(any)
  description = "list of subscription ids if you need to loop over subscriptions for one module"
  default = {
    "amap-teusshared01"   = "xxxxxx-xxxxxx-xxxxxx-xxxxx"
    "ece-dneushared01"    = "xxxxxx-xxxxxx-xxxxxx-xxxxx"
    "ece-dweushared01"    = "xxxxxx-xxxxxx-xxxxxx-xxxxx"
  }
}