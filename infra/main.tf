terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.25.2"
    }
  }
  backend "s3" {
    bucket = "ftf-tf-state"
    key    = "k8s/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "do_token" {
  description = "digital ocean access token"
  type        = string
}
variable "env" {
  description = "environment name"
  type        = string
  default     = "main"
}

provider "digitalocean" {
  # Configuration options
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name = "ftf-${var.env}-cluster"
  # same as DO container registry (which doesn't have nyc1)
  region  = "nyc3"
  version = "1.25.4-do.0"

  node_pool {
    name = "ftf-${var.env}-autoscale-worker-pool"
    # doctl kubernetes options sizes
    # NOTE: this is the smallest available size
    size       = "s-1vcpu-2gb"
    auto_scale = true
    # NOTE: you need a minimum of 2 nodes in order to have no downtime
    min_nodes = 2
    max_nodes = 3
  }
}
