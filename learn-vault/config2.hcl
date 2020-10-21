storage "file" {
  path = "/home/vagrant/vault-data"
}

listener "tcp" {
  tls_disable = 1
}

