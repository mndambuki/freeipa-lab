#cloud-config
hostname: ${hostname}
fqdn: ${fqdn}
manage_etc_hosts: false
ssh_pwauth: false
disable_root: false
users:
  - name: maintuser
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups:
      - sudo
    shell: /bin/bash
    lock_passwd: false
    ssh-authorized-keys:
      - ${ssh_pubkey}
packages:
  - qemu-guest-agent
write_files:
  # Root CA
  - path: /root/freeipa/certificates/root-ca.crt
    owner: root:root
    permissions: "0644"
    encoding: b64
    content: ${root_ca_certificate}
  # Directory Server
  - path: /root/freeipa/certificates/dirsrv.crt
    owner: root:root
    permissions: "0644"
    encoding: b64
    content: ${dirsrv_certificate}
  - path: /root/freeipa/certificates/dirsrv.key
    owner: root:root
    permissions: "0640"
    encoding: b64
    content: ${dirsrv_private_key}
  # Apache HTTP
  - path: /root/freeipa/certificates/httpd.crt
    owner: root:root
    permissions: "0644"
    encoding: b64
    content: ${httpd_certificate}
  - path: /root/freeipa/certificates/httpd.key
    owner: root:root
    permissions: "0640"
    encoding: b64
    content: ${httpd_private_key}

# every boot
bootcmd:
  - [ sh, -c, 'echo $(date) | sudo tee -a /root/bootcmd.log' ]

# run once for setup
runcmd:
  - [ sh, -c, 'echo $(date) | sudo tee -a /root/runcmd.log' ]
  - [ openssl, pkcs12, -export, -name, dirsrv-cert, -out, /root/freeipa/certificates/dirsrv.p12, -passout, "pass:", -inkey, /root/freeipa/certificates/dirsrv.key, -in, /root/freeipa/certificates/dirsrv.crt, -certfile, /root/freeipa/certificates/root-ca.crt ]
  - [ openssl, pkcs12, -export, -name, httpd-cert, -out, /root/freeipa/certificates/httpd.p12, -passout, "pass:", -inkey, /root/freeipa/certificates/httpd.key, -in, /root/freeipa/certificates/httpd.crt, -certfile, /root/freeipa/certificates/root-ca.crt ]

# written to /var/log/cloud-init-output.log
final_message: "The system is finall up, after $UPTIME seconds"
