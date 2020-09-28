resource "tls_private_key" "freeipa_replica_httpd" {

  count = local.num_freeipa_replicas

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "freeipa_replica_httpd" {

  count = local.num_freeipa_replicas

  private_key_pem = tls_private_key.freeipa_replica_httpd[count.index].private_key_pem
  key_algorithm   = tls_private_key.freeipa_replica_httpd[count.index].algorithm

  subject {
    common_name         = "Apache HTTP Server"
    organization        = "FreeIPA"
    organizational_unit = "Ansible FreeIPA"
    country             = "ES"
    locality            = "Madrid"
    province            = "Madrid"
  }

  dns_names = [
    local.freeipa_replicas[count.index].fqdn,
    format("console.%s", var.dns.domain)
  ]

  ip_addresses = [
    "127.0.0.1",
    local.freeipa_replicas[count.index].ip
  ]
}

resource "tls_locally_signed_cert" "freeipa_replica_httpd" {

  count = local.num_freeipa_replicas

  cert_request_pem      = tls_cert_request.freeipa_replica_httpd[count.index].cert_request_pem
  ca_cert_pem           = tls_self_signed_cert.freeipa_root_ca.cert_pem
  ca_private_key_pem    = tls_private_key.freeipa_root_ca.private_key_pem
  ca_key_algorithm      = tls_private_key.freeipa_root_ca.algorithm
  validity_period_hours = 8760
  is_ca_certificate     = false
  set_subject_key_id    = true

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth"
  ]
}

resource "local_file" "freeipa_replica_httpd_certificate_pem" {

  count = local.num_freeipa_replicas

  filename             = format(
    "output/ca/clients/freeipa-httpd/%s/certificate.pem",
    local.freeipa_replicas[count.index].hostname
  )
  content              = tls_locally_signed_cert.freeipa_replica_httpd[count.index].cert_pem
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "freeipa_replica_httpd_private_key_pem" {

  count = local.num_freeipa_replicas

  filename             = format(
    "output/ca/clients/freeipa-httpd/%s/private.key",
    local.freeipa_replicas[count.index].hostname
  )
  content              = tls_private_key.freeipa_replica_httpd[count.index].private_key_pem
  file_permission      = "0600"
  directory_permission = "0700"
}
