variable "hcloud_token" {}
variable "public_key" {}
variable "image" {}
variable "name" {}
 
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.26.0"
    }
  }
}
 
#Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}
 
# Create a new SSH key
resource "hcloud_ssh_key" "key" {
  name = "${var.name}-key"
  public_key = "${var.public_key}"
}
 
# Create a new server running debian
resource "hcloud_server" "node1" {
  name = "${var.name}-node"
  image = var.image
  server_type = "cx11"
  ssh_keys = [hcloud_ssh_key.key]
}
 
output ipv4 {
  value       = hcloud_server.node1.ipv4_address
  sensitive   = true
  description = "IPv4 of the generated vm"
  depends_on  = [hcloud_server.node1]
}
 
output ipv6 {
  value       = hcloud_server.node1.ipv6_address
  sensitive   = true
  description = "IPv6 of the generated vm"
  depends_on  = [hcloud_server.node1]
}
 
output id {
  value       = hcloud_server.node1.id
  sensitive   = true
  description = "description"
  depends_on  = []
}
