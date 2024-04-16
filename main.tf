variable "hcloud_token" {}
variable "public_key" {}
variable "image" {}
variable "name" {}
variable "server_type" {}
variable "location" {}
variable "cloud-config" {}
variable "labels" {
  type        = string
  default     = ""
  description = "Optional labels for the server in 'key1=value1,key2=value2' format"
}
variable "firewall_ids" {
  type        = string
  default     = ""
  description = "Optional firewall IDs for the server, comma-separated"
}
variable "poll_interval" {
  type        = string
  default     = "1000ms"
  description = "configures the interval in which actions are polled by the client. Increase if Rate Limiting Errors occur"
}


locals {
  labels_map = length(var.labels) > 0 ? { for pair in split(",", var.labels) : split("=", pair)[0] => split("=", pair)[1] } : {}
  firewall_ids_list = length(var.firewall_ids) > 0 ? split(",", var.firewall_ids) : []
}

locals {
  
}

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "~> 1.44.0"
    }
  }
  required_version = ">= 0.14.0"
}

#Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
  poll_interval = var.poll_interval
}

# Create a new SSH key
resource "hcloud_ssh_key" "key" {
  name = "${var.name}-key"
  public_key = var.public_key
}

# Create a new server running debian
resource "hcloud_server" "node1" {
  name = var.name
  image = var.image
  location = var.location
  server_type = var.server_type
  ssh_keys = ["${var.name}-key"]
  user_data = var.cloud-config

  labels = local.labels_map
  firewall_ids = length(local.firewall_ids_list) > 0 ? local.firewall_ids_list : null
}

output "private_ip" {
  value = hcloud_server.node1.ipv4_address
}

output "public_ip" {
  value = hcloud_server.node1.ipv4_address
}

output "hostname" {
  value = hcloud_server.node1.name
}
