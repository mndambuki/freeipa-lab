resource "tls_private_key" "freeipa_replica_pkinit" {

  count = local.num_freeipa_replicas

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "freeipa_replica_pkinit" {

  count = local.num_freeipa_replicas

  private_key_pem = tls_private_key.freeipa_replica_pkinit[count.index].private_key_pem
  key_algorithm   = tls_private_key.freeipa_replica_pkinit[count.index].algorithm

  subject {
    common_name         = "KDC"
    organization        = "FreeIPA"
    organizational_unit = "Ansible FreeIPA"
    country             = "ES"
    locality            = "Madrid"
    province            = "Madrid"
  }

  dns_names = [
    local.freeipa_replicas[count.index].fqdn,
    format("kdc.%s", var.dns.domain)
  ]

  ip_addresses = [
    "127.0.0.1",
    local.freeipa_replicas[count.index].ip
  ]
}

resource "local_file" "freeipa_replica_pkinit_csr" {

  count = local.num_freeipa_replicas

  filename             = format("%s/ca/clients/freeipa-pkinit/%s/certificate.req",
    path.module, local.freeipa_replicas[count.index].hostname)
  content              = tls_cert_request.freeipa_replica_pkinit[count.index].cert_request_pem
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "null_resource" "freeipa_replica_pkinit_certificate" {

  count = local.num_freeipa_replicas

  provisioner "local-exec" {
    environment = {
      REALM = upper(var.dns.domain)
    }

    command = <<-EOF
      openssl x509 -req \
        -in ${local_file.freeipa_replica_pkinit_csr[count.index].filename} \
        -CA ${local_file.freeipa_root_ca_certificate_pem.filename} \
        -CAkey ${local_file.freeipa_root_ca_private_key_pem.filename} \
        -extfile ${abspath("ca/clients/freeipa-pkinit/extensions.conf")} \
        -extensions kdc_cert \
        -CAcreateserial \
        -out "ca/clients/freeipa-pkinit/${local.freeipa_replicas[count.index].hostname}/certificate.pem" \
        -days 365
    EOF
  }
}

data "local_file" "freeipa_replica_pkinit_certificate_pem" {

  count = local.num_freeipa_replicas

  filename = format("%s/ca/clients/freeipa-pkinit/%s/certificate.pem",
    path.module, local.freeipa_replicas[count.index].hostname)

  # TODO: Will work when https://github.com/hashicorp/terraform/pull/24904 is closed
  depends_on = [
    null_resource.freeipa_replica_pkinit_certificate
  ]
}

resource "local_file" "freeipa_replica_pkinit_private_key_pem" {

  count = var.DEBUG ? local.num_freeipa_replicas : 0

  filename             = format("%s/ca/clients/freeipa-pkinit/%s/private.key",
    path.module, local.freeipa_replicas[count.index].hostname)
  content              = tls_private_key.freeipa_replica_pkinit[count.index].private_key_pem
  file_permission      = "0600"
  directory_permission = "0700"
}
