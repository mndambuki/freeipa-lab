# FreeIPA master
output "freeipa_master" {
  value = {
    fqdn       = local.freeipa_master.fqdn
    ip_address = local.freeipa_master.ip
    ssh        = format("ssh -i src/ssh/maintuser/id_rsa maintuser@%s", local.freeipa_master.fqdn)
  }
}

# FreeIPA replicas
output "freeipa_replicas" {
  value = {
    fqdn       = local.freeipa_replicas.*.fqdn
    ip_address = local.freeipa_replicas.*.ip
    ssh        = formatlist("ssh -i src/ssh/maintuser/id_rsa maintuser@%s", local.freeipa_replicas.*.fqdn)
  }
}

# FreeIPA bastion
output "freeipa_bastion" {
  value = {
    ip_address = libvirt_domain.freeipa_bastion.network_interface.0.addresses.0
    fqdn       = local.freeipa_bastion.fqdn
    ssh        = format("ssh -i src/ssh/maintuser/id_rsa maintuser@%s", local.freeipa_bastion.fqdn)
  }
}
