#!/bin/bash

# Run as root

# Add HC GPG key and official Linux repo, update and install
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install terraform

# TF autocomplete
terraform -install-autocomplete

# Install docker
apt-get update -y && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Check fingerprint
cat <<'EOF' |  diff - <(apt-key fingerprint 0EBFCD88)
pub   4096R/0EBFCD88 2017-02-22
      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22

EOF
if [ $? -ne 0 ]; then
    echo "Error with docker fingerprint"
    exit 1
fi

# Get stable repo for docker
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Docker engine
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Start docker on boot
systemctl enable docker
