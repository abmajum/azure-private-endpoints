variable "cluster_name" {
  type        = string
  description = "The name of the source cluster we are adding the private endpoint to"
}

variable "dns_zone_name" {
  type        = string
  description = "The name of the dns zone we are creating"
}

variable "subresource_name" {
  type        = string
  description = "The name of the service we are connecting to"
}

variable "subscription_id" {
  type        = string
  description = "The subscription id we are deploying the private endpoint to"
}

variable "environment" {
  type        = string
  description = "the environment we are deploying to"
}