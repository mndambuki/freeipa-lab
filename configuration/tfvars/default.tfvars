freeipa_master = {
  id       = "ipaserver"
  base_img = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2"
  vcpu     = 2
  memory   = 2048
}

freeipa_replica = {
  id       = "ipareplica"
  base_img = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2"
  vcpu     = 2
  memory   = 2048
}

freeipa_bastion = {
  id       = "ipabastion"
  base_img = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2"
  vcpu     = 1
  memory   = 1024
}