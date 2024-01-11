#!/usr/bin/env bash

function remove_old_packages {
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done
}

function add_repo {
  # Add Docker's official GPG key:
  apt-get update
  apt-get install -y ca-certificates curl gnupg
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
}

function install_docker {
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}
if [[ "$UID" -ne "0" ]]; then
  echo "This script must be run as root or with sudo!"
  exit 1
else
  echo "Removing old packages!"
  remove_old_packages

  echo "Adding Docker apt repo"
  add_repo

  echo "Installing Docker"
  install_docker
fi

exit 0

