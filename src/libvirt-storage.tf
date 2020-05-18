resource "libvirt_pool" "freeipa" {
  name = var.libvirt.pool
  type = "dir"
  path = var.libvirt.pool_path
}