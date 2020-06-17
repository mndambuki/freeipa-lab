data "template_file" "freeipa_replica_dns_srv_records" {

  count = local.num_freeipa_replicas

  template = file(format("%s/dns/records-srv.xml.tpl", path.module))

  vars = {
    freeipa_host_fqdn = local.freeipa_replicas[count.index].fqdn
  }
}

data "template_file" "freeipa_replica_dns_ptr_records" {

  count = local.num_freeipa_replicas

  template = file(format("%s/dns/records-ptr.xml.tpl", path.module))

  vars = {
    freeipa_host_ptr  = join(".", reverse(split(".", local.freeipa_replicas[count.index].ip)))
    freeipa_host_fqdn = local.freeipa_replicas[count.index].fqdn
  }
}