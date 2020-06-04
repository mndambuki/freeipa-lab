#!/usr/bin/env bash

set -o errexit  # exit when a command fails
set -o nounset  # exit when use undeclared variables
set -o pipefail # return the exit code of the last command that threw a non-zero

export CERTIFICATES_DIR=$1
export REALM=$2
export PRIVATE_KEY_SIZE="4096"

# Generate CSR for LDAPS and HTTPS
openssl req -new -nodes -sha256 \
    -config ${CERTIFICATES_DIR}/tls/csr-tls.conf \
    -newkey rsa:${PRIVATE_KEY_SIZE} \
    -out ${CERTIFICATES_DIR}/tls/certificate.csr \
    -keyout ${CERTIFICATES_DIR}/tls/private.key

# Verify generated for LDAPS and HTTPS
openssl req -verify -text -noout \
    -in ${CERTIFICATES_DIR}/tls/certificate.csr

# Generate CSR for PKINIT
openssl req -new -nodes -sha256 \
    -config ${CERTIFICATES_DIR}/pkinit/csr-pkinit.conf \
    -newkey rsa:${PRIVATE_KEY_SIZE} \
    -out ${CERTIFICATES_DIR}/pkinit/certificate.csr \
    -keyout ${CERTIFICATES_DIR}/pkinit/private.key

# Verify generated for PKINIT
openssl req -verify -text -noout \
    -in ${CERTIFICATES_DIR}/pkinit/certificate.csr