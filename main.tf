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

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "~> 1.41.0"
    }
  }
  required_version = ">= 0.14.0"
}

#Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
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
  
  dynamic "labels" {
    for_each = length(var.labels) > 0 ? { for pair in split(",", var.labels) : split("=", pair)[0] => split("=", pair)[1] } : {}
    content {
      key   = labels.key
      value = labels.value
    }
  }

  dynamic "firewall" {
    for_each = length(var.firewall_ids) > 0 ? split(",", var.firewall_ids) : []
    content {
      firewall_id = firewall.value
    }
  }
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
