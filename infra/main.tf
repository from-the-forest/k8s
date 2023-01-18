terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.25.2"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  # Configuration options
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "ftf-cluster" {
  name    = "ftf-cluster"
  region  = "nyc1"
  version = "1.25.4-do.0"

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }
}
