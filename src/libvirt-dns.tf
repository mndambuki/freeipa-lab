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
