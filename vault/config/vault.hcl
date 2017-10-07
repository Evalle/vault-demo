backend "file" {
  path = "/vault/file"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = 0
  tls_client_ca_file = "/vault/pki/ca.pem"
  tls_cert_file = "/vault/pki/vault.pem"
  tls_key_file = "/vault/pki/vault.key"
  tls_min_version = "tls12"
  tls_prefer_server_cipher_suites = "true"
  # tls_cipher_suites = "TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
}

default_lease_ttl = "168h"
max_lease_ttl = "720h"
