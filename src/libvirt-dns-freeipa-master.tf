data "template_file" "freeipa_master_dns_srv_records" {
  template = file(format("%s/dns/records-srv.xml.tpl", path.module))

  vars = {
    freeipa_host_fqdn = local.freeipa_master.fqdn
  }
}

data "template_file" "freeipa_master_dns_ptr_records" {
  template = file(format("%s/dns/records-ptr.xml.tpl", path.module))

  vars = {
    freeipa_host_ptr  = join(".", reverse(split(".", local.freeipa_master.ip)))
    freeipa_host_fqdn = local.freeipa_master.fqdn
  }
}
