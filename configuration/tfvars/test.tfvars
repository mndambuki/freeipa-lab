libvirt = {
  pool      = "freeipa"
  pool_path = "/var/lib/libvirt/storage/freeipa"
}

network = {
  name    = "freeipa"
  subnet  = "10.2.0.0/24"
  gateway = "10.2.0.1"
}

dns = {
  domain = "test.local"
  server = "10.2.0.1"
}

freeipa_inventory = {
  "master" = {
    ip_address  = "10.2.0.10"
    mac_address = "0A:00:00:00:00:00"
  }
  "replica00" = {
    ip_address  = "10.2.0.11"
    mac_address = "0A:00:00:00:00:01"
  }
}