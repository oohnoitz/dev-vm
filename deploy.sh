#!/usr/bin/env bash

# This script will be used to provision our development environment in an orderly fashion. It
# will contain all essential software installations upon it's deployment.

mkdir -p ~/.deploy

if [ ! -f ~/.deploy/env-000 ]
then
  mkdir -p /opt/deploy

  # modify hostname
  cp /vagrant/deploy/hostname.sh /opt/deploy/hostname
  chmod +x /opt/deploy/hostname
  bash -x /opt/deploy/hostname

  # update mirror
  cp /vagrant/deploy/apt.sh /opt/deploy/apt
  chmod +x /opt/deploy/apt
  bash -x /opt/deploy/apt

  # update distro and install systemd & essentials
  apt-get update
  apt-get upgrade
  yes "Yes, do as I say!" | apt-get install -y --force-yes systemd systemd-sysv
  apt-get install -y imagemagick git build-essential libpcre3-dev libssl-dev unzip

  echo "------------------------------------------------------------------------------------"
  echo " YOU WILL NEED TO COMPLETE THE DEPLOYMENT BY CALLING: vagrant reload --provision    "
  echo "------------------------------------------------------------------------------------"
fi

if [ -f ~/.deploy/env-000 ]
then
  mkdir -p /opt/deploy
  cp /vagrant/deploy/install.sh /opt/deploy/install
  chmod +x /opt/deploy/install
  bash -x /opt/deploy/install
fi

touch ~/.deploy/env-000
