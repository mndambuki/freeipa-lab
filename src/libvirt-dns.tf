data "template_file" "freeipa_dns_txt_records" {
  template = file(format("%s/dns/records-txt.xml.tpl", path.module))

  vars = {
    kerberos_realm = upper(var.dns.domain)
  }
}

data "template_file" "freeipa_dns_records" {

  template = file(format("%s/dns/libvirt-network-dns.xml.tpl", path.module))

  vars = {
    dns_srv_records = indent(12,
      format("%s\n%s",
        data.template_file.freeipa_master_dns_srv_records.rendered,
        join("\n", data.template_file.freeipa_replica_dns_srv_records.*.rendered)
      )
    )
    dns_ptr_records = indent(12,
      format("%s\n%s",
        data.template_file.freeipa_master_dns_ptr_records.rendered,
        join("\n", data.template_file.freeipa_replica_dns_ptr_records.*.rendered)
      )
    )
    dns_txt_records = indent(12, data.template_file.freeipa_dns_txt_records.rendered)
  }
}

data "template_file" "freeipa_dnsmasq" {

  template = file(format("%s/dns/freeipa_dnsmasq.conf.tpl", path.module))

  vars = {
    dns_zone   = var.dns.domain
    dns_server = var.network.gateway
  }
}

resource "local_file" "nm_enable_dnsmasq" {
  filename             = "/etc/NetworkManager/conf.d/nm_enable_dnsmasq.conf"
  content              = file(format("%s/dns/nm_enable_dnsmasq.conf", path.module))
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "freeipa_dnsmasq" {
  filename             = "/etc/NetworkManager/dnsmasq.d/freeipa_dnsmasq.conf"
  content              = data.template_file.freeipa_dnsmasq.rendered
  file_permission      = "0644"
  directory_permission = "0755"

  provisioner "local-exec" {
    command = "sudo systemctl restart NetworkManager"
  }

  depends_on = [
    local_file.nm_enable_dnsmasq
  ]
}
