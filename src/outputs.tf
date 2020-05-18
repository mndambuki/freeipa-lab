# FreeIPA bastion
output "freeipa_bastion" {
  value = {
    ip_address = libvirt_domain.freeipa_bastion.network_interface.0.addresses.0
    fqdn       = libvirt_domain.freeipa_bastion.network_interface.0.hostname
    ssh        = format("ssh -i src/ssh/maintuser/id_rsa maintuser@%s",
      libvirt_domain.freeipa_bastion.network_interface.0.hostname)
  }
}

# FreeIPA master
output "freeipa_master" {
  value = {
    ip_address = libvirt_domain.freeipa_master.network_interface.0.addresses.0
    fqdn       = libvirt_domain.freeipa_master.network_interface.0.hostname
    ssh        = format("ssh -i src/ssh/maintuser/id_rsa maintuser@%s",
      libvirt_domain.freeipa_master.network_interface.0.hostname)
  }
}