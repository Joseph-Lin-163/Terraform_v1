#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Error: command expects 1 argument, $# supplied."
    exit 1
fi

echo "Revoking certificate with serial number: $1"
vault write pki_int/revoke serial_number=$1

if [ $? -ne 0 ]; then
    echo "Error revoking certificate. Serial number doesn't exist or certificate expired."
    exit 1
else
    echo "Revoked certificate with serial number: $1."
    exit 0
fi
