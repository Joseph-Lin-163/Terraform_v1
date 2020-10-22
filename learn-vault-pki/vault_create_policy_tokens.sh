#!/bin/bash

vault policy write admin admin-policy.hcl
vault policy write ca-auth ca-auth-policy.hcl
vault token create -policy=admin
vault token create -policy=ca-auth
