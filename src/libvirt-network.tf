resource "libvirt_network" "freeipa" {
  name      = var.network.name
  domain    = var.dns.domain
  mode      = "route"
  bridge    = "virbr-freeipa"
  mtu       = 1500
  addresses = [ var.network.subnet ]
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = true
  }

  xml {
    xslt = data.template_file.freeipa_dns_records.rendered
  }

  depends_on = [
    local_file.freeipa_dnsmasq
  ]
}
