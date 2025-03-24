#!/bin/bash

# Directory for certificates
CERT_DIR="/home/ec2-user/frp/certs"
mkdir -p $CERT_DIR
cd $CERT_DIR

# Copy OpenSSL config
cat > my-openssl.cnf << EOF
[ ca ]
default_ca = CA_default
[ CA_default ]
x509_extensions = usr_cert
[ req ]
default_bits        = 2048
default_md          = sha256
default_keyfile     = privkey.pem
distinguished_name  = req_distinguished_name
attributes          = req_attributes
x509_extensions     = v3_ca
string_mask         = utf8only
[ req_distinguished_name ]
[ req_attributes ]
[ usr_cert ]
basicConstraints       = CA:FALSE
nsComment              = "OpenSSL Generated Certificate"
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer
[ v3_ca ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints       = CA:true
EOF

# Build CA certificate
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj "/CN=frp.${DOMAIN}" -days 3650 -out ca.crt

# Build server certificate
openssl genrsa -out server.key 2048
openssl req -new -sha256 -key server.key \
    -subj "/C=US/ST=Default/L=Default/O=Default/CN=frp.${DOMAIN}" \
    -reqexts SAN \
    -config <(cat my-openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:frp.${DOMAIN},DNS:*.frp.${DOMAIN},IP:127.0.0.1")) \
    -out server.csr

openssl x509 -req -days 3650 -sha256 \
    -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -extfile <(printf "subjectAltName=DNS:frp.${DOMAIN},DNS:*.frp.${DOMAIN},IP:127.0.0.1") \
    -out server.crt

# Build client certificate
openssl genrsa -out client.key 2048
openssl req -new -sha256 -key client.key \
    -subj "/C=US/ST=Default/L=Default/O=Default/CN=frpc-client" \
    -reqexts SAN \
    -config <(cat my-openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:frpc-client")) \
    -out client.csr

openssl x509 -req -days 3650 -sha256 \
    -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -extfile <(printf "subjectAltName=DNS:frpc-client") \
    -out client.crt

# Set permissions
chmod 644 *.crt
chmod 600 *.key

echo "Certificates created successfully"
