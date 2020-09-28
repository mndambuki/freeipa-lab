terraform {
  required_version = ">= 0.13.0"

  backend "local" {}

  required_providers {

    libivrt = {
      source  = "hashicorp/libvirt"
      version = "~> 0.6.2"
    }

  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
