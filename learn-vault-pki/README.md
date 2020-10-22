# Steps to run this vault config

1. Run `vault_setup.sh`.
2. Run `vault server -config=config.hcl` and unseal the vault or operator init on new vault raft.
3. Run `vault_create_policy_tokens.sh` and save tokens.
4. Login with `ca-auth` using token.
5. Run `vault_generate_certificates.sh`. Only run once as this generates the root and intermediate certificates and sets up the role for issuances and revocation of leaf certificates.
6. Issue a test certificate: `./issue_cert.sh test.example.com`
7. Revoke test certificate: `./revoke_cert [serial_number]`
8. Maintain CRL by removing any expired and revoked certs: `./remove_expired_and_revoked_certs.sh`
