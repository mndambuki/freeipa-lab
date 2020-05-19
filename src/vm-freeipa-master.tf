locals {
  freeipa_master = {
    hostname    = "master"
    fqdn        = format("master.%s", var.dns.domain)
    ip_address  = lookup(var.freeipa_inventory, "master").ip_address
    mac_address = lookup(var.freeipa_inventory, "master").mac_address
  }
}

data "template_file" "freeipa_master_cloudinit" {

  template = file(format("%s/cloudinit/vm-freeipa-master-userdata.yml.tpl", path.module))

  vars = {
    hostname   = local.freeipa_master.hostname
    fqdn       = local.freeipa_master.fqdn
    ssh_pubkey = trimspace(tls_private_key.ssh_maintuser.public_key_openssh)

    root_ca_certificate = base64encode(tls_self_signed_cert.freeipa_root_ca.cert_pem)
    dirsrv_certificate  = base64encode(tls_locally_signed_cert.freeipa_dirsrv.cert_pem)
    dirsrv_private_key  = base64encode(tls_private_key.freeipa_dirsrv.private_key_pem)
    httpd_certificate   = base64encode(tls_locally_signed_cert.freeipa_httpd.cert_pem)
    httpd_private_key   = base64encode(tls_private_key.freeipa_httpd.private_key_pem)
    pkinit_certificate  = base64encode(data.local_file.freeipa_pkinit_certificate_pem.content)
    pkinit_private_key  = base64encode(tls_private_key.freeipa_pkinit.private_key_pem)
  }
}

resource "libvirt_cloudinit_disk" "freeipa_master" {
  name      = format("cloudinit-%s.qcow2", local.freeipa_master.hostname)
  pool      = libvirt_pool.freeipa.name
  user_data = data.template_file.freeipa_master_cloudinit.rendered
}

resource "libvirt_volume" "freeipa_master_image" {
  name   = format("%s-baseimg.qcow2", local.freeipa_master.hostname)
  pool   = libvirt_pool.freeipa.name
  source = var.freeipa_master.base_img
  format = "qcow2"
}

resource "libvirt_volume" "freeipa_master" {
  name           = format("%s-volume.qcow2", local.freeipa_master.hostname)
  pool           = libvirt_pool.freeipa.name
  base_volume_id = libvirt_volume.freeipa_master_image.id
  format         = "qcow2"
}

resource "libvirt_domain" "freeipa_master" {
  name   = format("freeipa-%s", local.freeipa_master.hostname)
  memory = var.freeipa_master.memory
  vcpu   = var.freeipa_master.vcpu

  cloudinit = libvirt_cloudinit_disk.freeipa_master.id

  disk {
    volume_id = libvirt_volume.freeipa_master.id
    scsi      = false
  }

  network_interface {
    network_name   = libvirt_network.freeipa.name
    hostname       = local.freeipa_master.fqdn
    addresses      = [ local.freeipa_master.ip_address ]
    mac            = local.freeipa_master.mac_address
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
