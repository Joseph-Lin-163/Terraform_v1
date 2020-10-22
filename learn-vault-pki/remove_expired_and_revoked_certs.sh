#!/bin/bash

echo "Cleaning expired and revoked certificates."
vault write pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true

if [ $? -ne 0 ]; then
    echo "Error cleaning expired and revoked certificates."
    exit 1
else
    echo "Cleaned expired and revoked certificates."
    exit 0
fi
