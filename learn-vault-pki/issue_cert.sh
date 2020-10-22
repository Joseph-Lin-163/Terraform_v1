#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Error: command expects 1 argument, $# supplied."
    exit 1
fi

echo "Issuing certificate for $1 with TTL: 24h."
vault write pki_int/issue/example-dot-com common_name="$1" ttl="24h"

if [ $? -ne 0 ]; then
    echo "Error issuing certificate. Common name doesn't match parameters set forth in policy."
    exit 1
else
    echo "Issued certificate for $1."
    exit 0
fi
