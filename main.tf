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
  token = "${var.hcloud_token}"
}
 
# Create a new SSH key
resource "hcloud_ssh_key" "key" {
  name = "${var.name}-key"
  public_key = "${var.public_key}"
}
 
# Create a new server running debian
resource "hcloud_server" "node1" {
  name = "${var.name}-node"
  image = "${var.image}"
  server_type = "cx11"
  ssh_keys = ["${var.name}-key"]
}


output "private_ip" {
  value = "${hcloud_server.node1.ipv4_address}"
}

output "public_ip" {
  value = "${hcloud_server.node1.ipv4_address}"
}

output "hostname" {
  value = "${hcloud_server.node1.name}"
}

 
