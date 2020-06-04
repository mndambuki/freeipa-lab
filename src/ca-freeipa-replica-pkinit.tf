resource "tls_private_key" "freeipa_replica_pkinit" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "freeipa_replica_pkinit" {
  private_key_pem = tls_private_key.freeipa_replica_pkinit.private_key_pem
  key_algorithm   = tls_private_key.freeipa_replica_pkinit.algorithm

  subject {
    common_name         = "KDC"
    organization        = "FreeIPA"
    organizational_unit = "Ansible FreeIPA"
    country             = "ES"
    locality            = "Madrid"
    province            = "Madrid"
  }

  dns_names = [
    local.freeipa_replica.fqdn,
    format("kdc.%s", var.dns.domain)
  ]

  ip_addresses = [
    "127.0.0.1",
    local.freeipa_replica.ip
  ]
}

resource "local_file" "freeipa_replica_pkinit_csr" {
  filename             = format("%s/ca/clients/freeipa-pkinit/replica/certificate.req", path.module)
  content              = tls_cert_request.freeipa_replica_pkinit.cert_request_pem
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "null_resource" "freeipa_replica_pkinit_certificate" {
  provisioner "local-exec" {
    environment = {
      REALM = upper(var.dns.domain)
    }

    command = format("openssl x509 -req -in %s -CA %s -CAkey %s -extfile %s -extensions kdc_cert -CAcreateserial -out %s -days 365 ",
      local_file.freeipa_replica_pkinit_csr.filename,
      local_file.freeipa_root_ca_certificate_pem.filename,
      local_file.freeipa_root_ca_private_key_pem.filename,
      format("%s/ca/clients/freeipa-pkinit/extensions.conf", path.module),
      format("%s/ca/clients/freeipa-pkinit/replica/certificate.pem", path.module))
  }

  provisioner "local-exec" {
    when    = destroy
    command = format("rm -f %s/ca/clients/freeipa-pkinit/replica/certificate.pem", path.module)
  }
}

data "local_file" "freeipa_replica_pkinit_certificate_pem" {
  filename = format("%s/ca/clients/freeipa-pkinit/replica/certificate.pem", path.module)

  # TODO: Will work when https://github.com/hashicorp/terraform/pull/24904 is closed
  depends_on = [
    null_resource.freeipa_replica_pkinit_certificate
  ]
}

resource "local_file" "freeipa_replica_pkinit_private_key_pem" {

  count = var.DEBUG ? 1 : 0

  filename             = format("%s/ca/clients/freeipa-pkinit/replica/private.key", path.module)
  content              = tls_private_key.freeipa_replica_pkinit.private_key_pem
  file_permission      = "0600"
  directory_permission = "0700"
}
