ui = true
disable_mlock = true

storage "raft" {
  path    = "/home/vagrant/vault-data-ui"
  node_id = "node1"
}

listener "tcp" {
  address     = "0.0.0.0:8000"
  tls_disable = 1
}

api_addr = "http://127.0.0.1:8000"
cluster_addr = "https://127.0.0.1:8001"
