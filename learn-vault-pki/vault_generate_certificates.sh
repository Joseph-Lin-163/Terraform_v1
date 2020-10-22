#!/bin/bash

# This script is meant to be run with ca-auth-policy

# Acquire root certificate
# Enable pki secrets engine at pki path
vault secrets enable pki

# Tune pki secrets engine for TTL of 87600 hours
vault secrets tune -max-lease-ttl=87600h pki

# Write the root certificate with common_name into CA_cert.crt
# Note: This generates a new self-signed CA certificate and private key. Vault will automatically revoke the generated root at the end of its lease period (TTL); the CA certificate will sign its own Certificate Revocation List (CRL).
vault write -field=certificate pki/root/generate/internal common_name="example.com" ttl=87600h > CA_cert.crt

# Configure the CA and CRL URLs.
vault write pki/config/urls issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"

# Acquire intermediate certs
# Enable the pki secrets engine at the pki_int path
vault secrets enable -path=pki_int pki

# Tune the pki_int secrets engine to issue certificates with a maximum time-to-live (TTL) of 43800 hours
vault secrets tune -max-lease-ttl=43800h pki_int

# Generate an intermediate and save the CSR as pki_intermediate.csr
vault write -format=json pki_int/intermediate/generate/internal \
        common_name="example.com Intermediate Authority" \
        | jq -r '.data.csr' > pki_intermediate.csr

# Sign the intermediate certificate with the root certificate and save the generated certificate as intermediate.cert.pem
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
        format=pem_bundle ttl="43800h" \
        | jq -r '.data.certificate' > intermediate.cert.pem

# Once the CSR is signed and the root CA returns a certificate, it can be imported back into Vault
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem

# Create the role which allows subdomains
# A role is a logical name that maps to a policy used to generate those credentials. It allows configuration parameters to control certificate common names, alternate names, the key uses that they are valid for, and more.
vault write pki_int/roles/example-dot-com \
        allowed_domains="example.com" \
        allow_subdomains=true \
        max_ttl="720h"
