locals {
  freeipa_bastion = {
    hostname = "bastion"
    fqdn     = format("bastion.%s", var.dns.domain)
  }
}

data "template_file" "freeipa_bastion_cloudinit" {

  template = file(format("%s/cloudinit/vm-freeipa-bastion-userdata.yml.tpl", path.module))

  vars = {
    hostname   = local.freeipa_bastion.hostname
    fqdn       = local.freeipa_bastion.fqdn
    ssh_pubkey = trimspace(tls_private_key.ssh_maintuser.public_key_openssh)
  }
}

resource "libvirt_cloudinit_disk" "freeipa_bastion" {
  name      = format("cloudinit-%s.qcow2", local.freeipa_bastion.hostname)
  pool      = libvirt_pool.freeipa.name
  user_data = data.template_file.freeipa_bastion_cloudinit.rendered
}

resource "libvirt_volume" "freeipa_bastion_image" {
  name   = format("%s-baseimg.qcow2", local.freeipa_bastion.hostname)
  pool   = libvirt_pool.freeipa.name
  source = var.freeipa_bastion.base_img
  format = "qcow2"
}

resource "libvirt_volume" "freeipa_bastion" {
  name           = format("%s-volume.qcow2", local.freeipa_bastion.hostname)
  pool           = libvirt_pool.freeipa.name
  base_volume_id = libvirt_volume.freeipa_bastion_image.id
  format         = "qcow2"
}

resource "libvirt_domain" "freeipa_bastion" {
  name   = format("freeipa-%s", local.freeipa_bastion.hostname)
  memory = var.freeipa_bastion.memory
  vcpu   = var.freeipa_bastion.vcpu

  cloudinit = libvirt_cloudinit_disk.freeipa_bastion.id

  disk {
    volume_id = libvirt_volume.freeipa_bastion.id
    scsi      = false
  }

  network_interface {
    hostname       = local.freeipa_bastion.fqdn
    network_name   = libvirt_network.freeipa.name
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
