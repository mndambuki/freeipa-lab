# Infrastructure environment
variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

# Libvirt configuration
variable "libvirt" {
  description = "Libvirt configuration"
  type = object({
    pool      = string,
    pool_path = string
  })
}

variable "network" {
  description = "Network configuration"
  type = object({
    name    = string,
    subnet  = string,
    gateway = string
  })
}

# DNS configuration
variable "dns" {
  description = "DNS configuration"
  type = object({
    domain = string,
    server = string
  })
}

# FreeIPA inventory
variable "freeipa_inventory" {
  description = "List of FreeIPA cluster nodes"
  type        = map(object({
    ip_address  = string,
    mac_address = string
  }))
}

# FreeIPA masters specification
variable "freeipa_master" {
  description = "Configuration for FreeIPA master virtual machine"
  type = object({
    id       = string,
    base_img = string,
    vcpu     = number,
    memory   = number
  })
}

# FreeIPA replicas specification
variable "freeipa_replica" {
  description = "Configuration for FreeIPA replica virtual machine"
  type = object({
    id       = string,
    base_img = string,
    vcpu     = number,
    memory   = number
  })
}

# FreeIPA bastion specification
variable "freeipa_bastion" {
  description = "Configuration for FreeIPA bastion virtual machine"
  type = object({
    id       = string,
    base_img = string,
    vcpu     = number,
    memory   = number
  })
}
