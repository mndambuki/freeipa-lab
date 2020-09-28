libvirt = {
  pool      = "freeipa"
  pool_path = "/var/lib/libvirt/images/freeipa"
}

network = {
  name    = "freeipa"
  subnet  = "10.1.0.0/24"
  gateway = "10.1.0.1"
}

dns = {
  domain = "test.local"
  server = "10.1.0.1"
}

freeipa_inventory = {
  "ipaserver" = {
    ip_address  = "10.1.0.10"
    mac_address = "0A:00:00:00:00:00"
  }
  "ipareplica00" = {
    ip_address  = "10.1.0.11"
    mac_address = "0A:00:00:00:00:01"
  }
  "ipareplica01" = {
    ip_address  = "10.1.0.12"
    mac_address = "0A:00:00:00:00:02"
  }
}
