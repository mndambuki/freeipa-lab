locals {
  freeipa_replica = {
    hostname = "ipareplica"
    fqdn     = format("ipareplica.%s", var.dns.domain)
    ip       = lookup(var.freeipa_inventory, "replica00").ip_address
    mac      = lookup(var.freeipa_inventory, "replica00").mac_address
  }
}

data "template_file" "freeipa_replica_cloudinit" {

  template = file(format("%s/cloudinit/vm-freeipa-replica-userdata.yml.tpl", path.module))

  vars = {
    hostname   = local.freeipa_replica.hostname
    fqdn       = local.freeipa_replica.fqdn
    ssh_pubkey = trimspace(tls_private_key.ssh_maintuser.public_key_openssh)

    root_ca_certificate = base64encode(tls_self_signed_cert.freeipa_root_ca.cert_pem)
    dirsrv_certificate  = base64encode(tls_locally_signed_cert.freeipa_replica_dirsrv.cert_pem)
    dirsrv_private_key  = base64encode(tls_private_key.freeipa_replica_dirsrv.private_key_pem)
    httpd_certificate   = base64encode(tls_locally_signed_cert.freeipa_replica_httpd.cert_pem)
    httpd_private_key   = base64encode(tls_private_key.freeipa_replica_httpd.private_key_pem)
    pkinit_certificate  = base64encode(data.local_file.freeipa_replica_pkinit_certificate_pem.content)
    pkinit_private_key  = base64encode(tls_private_key.freeipa_replica_pkinit.private_key_pem)
  }
}

resource "libvirt_cloudinit_disk" "freeipa_replica" {
  name      = format("cloudinit-%s.qcow2", local.freeipa_replica.hostname)
  pool      = libvirt_pool.freeipa.name
  user_data = data.template_file.freeipa_replica_cloudinit.rendered

  lifecycle {
    ignore_changes = [
      user_data
    ]
  }
}

resource "libvirt_volume" "freeipa_replica_image" {
  name   = format("%s-baseimg.qcow2", local.freeipa_replica.hostname)
  pool   = libvirt_pool.freeipa.name
  source = var.freeipa_replica.base_img
  format = "qcow2"
}

resource "libvirt_volume" "freeipa_replica" {
  name           = format("%s-volume.qcow2", local.freeipa_replica.hostname)
  pool           = libvirt_pool.freeipa.name
  base_volume_id = libvirt_volume.freeipa_replica_image.id
  format         = "qcow2"
}

resource "libvirt_domain" "freeipa_replica" {
  name   = format("freeipa-%s", local.freeipa_replica.hostname)
  memory = var.freeipa_replica.memory
  vcpu   = var.freeipa_replica.vcpu

  cloudinit = libvirt_cloudinit_disk.freeipa_replica.id

  disk {
    volume_id = libvirt_volume.freeipa_replica.id
    scsi      = false
  }

  network_interface {
    network_name   = libvirt_network.freeipa.name
    hostname       = local.freeipa_replica.fqdn
    addresses      = [ local.freeipa_replica.ip ]
    mac            = local.freeipa_replica.mac
    wait_for_lease = true
  }

  console {
    type           = "pty"
    target_type    = "serial"
    target_port    = "0"
    source_host    = "127.0.0.1"
    source_service = "0"
  }

  graphics {
    type           = "spice"
    listen_type    = "address"
    listen_address = "127.0.0.1"
    autoport       = true
  }

  provisioner "local-exec" {
    when    = destroy
    command = format("ssh-keygen -R %s || true", self.network_interface.0.hostname)
  }
}
