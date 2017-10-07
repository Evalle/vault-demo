# TLS

## Own CA


```
cat > openssl.cnf << EOF
[ req ]
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_ca ]
basicConstraints = critical, CA:TRUE
keyUsage = critical, digitalSignature, keyEncipherment, keyCertSign
[ v3_req_server ]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
[ v3_req_client ]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
[ v3_req_vaultserver ]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names_cluster
[ alt_names_cluster ]
DNS.1 = localhost
EOF
```


EC

```
openssl ecparam -name secp521r1 -genkey -noout -out ca.key
chmod 0600 ca.key
```

Or RSA

```
openssl genrsa -out ca.key 4096
chmod 0600 ca.key
```

```
openssl req -x509 -new -sha256 -nodes -key ca.key -days 3650 -out ca.pem \
            -subj "/CN=localhost"  -extensions v3_ca -config ./openssl.cnf
```


EC

```
openssl ecparam -name secp521r1 -genkey -noout -out vault.key
chmod 0600 vault.key
```

Or RSA

```
openssl genrsa -out vault.key 4096
chmod 0600 vault.key
```

```
openssl req -new -sha256 -key vault.key -subj "/CN=vault" \
  | openssl x509 -req -sha256 -CA ca.pem -CAkey ca.key -CAcreateserial \
                 -out vault.pem -days 365 \
                 -extensions v3_req_vaultserver -extfile ./openssl.cnf
```

```
cp -p vault.key vault.pem ca.pem vault/pki/
```


```
$ curl --cacert ca.pem https://localhost:8200/v1/sys/seal-status
{"errors":["server is not yet initialized"]}
```

```
export VAULT_ADDR=https://localhost:8200
export VAULT_CACERT=$(pwd)/ca.pem
vault status
```

```
nmap --script +ssl-enum-ciphers -p 8200 localhost
```
