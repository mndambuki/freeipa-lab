resource "libvirt_network" "freeipa" {
  name      = var.network.name
  domain    = var.dns.domain
  mode      = "nat"
  bridge    = "freeipavirbr0"
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

  # xml {
  #   xslt = file(format("%s/xslt/network-zone.xml", path.module))
  # }

  depends_on = [
    local_file.freeipa_dnsmasq
  ]
}