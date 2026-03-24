#!/bin/env sh
set -exu -o pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install apt-utils curl unzip tar pipx

pipx install ansible-core
pipx ensurepath --force

ansible-galaxy collection install community.general
