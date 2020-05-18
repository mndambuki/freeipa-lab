libvirt = {
  pool      = "freeipa"
  pool_path = "/var/lib/libvirt/storage/freeipa"
}

network = {
  name    = "freeipa"
  subnet  = "10.1.0.0/24"
  gateway = "10.1.0.1"
}

dns = {
  domain = "freeipa.libvirt.int"
  server = "10.1.0.1"
}
