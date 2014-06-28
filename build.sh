#!/usr/bin/env bash

# This script will be used to provision our development environment.
export DEBIAN_FRONTEND=noninteractive

mkdir -p ~/.build-env
if [ ! -f ~/.build-env/000 ]
then
  # modify hostname
  bash -x /vagrant/.provision/modify-hostname

  # update mirror
  bash -x /vagrant/.provision/update-apt-source

  # update distro
  apt-get update

  # install systemd
  yes "Yes, do as I say!" | apt-get install -y --force-yes systemd systemd-sysv
  apt-get upgrade -y

  # install essentials and ansible dependencies
  apt-get install -y build-essential git libpcre3-dev libssl-dev unzip
  apt-get install -y python-yaml python-jinja2 python-paramiko sshpass

  # checkout ansible
  git clone https://github.com/ansible/ansible.git /usr/local/ansible

  # configure ansible
  mkdir -p /etc/ansible
  echo "localhost" > /etc/ansible/hosts
  echo "source /usr/local/ansible/hacking/env-setup > /dev/null" >> /root/.bashrc
  echo "source /usr/local/ansible/hacking/env-setup > /dev/null" >> /home/vagrant/.bashrc

  # configure ssh keys for ansible
  ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

  echo "------------------------------------------------------------------------------------"
  echo " YOU WILL NEED TO COMPLETE THE PROVISIONING BY CALLING: vagrant reload --provision  "
  echo "------------------------------------------------------------------------------------"
fi

if [ -f ~/.build-env/000 ]
then
  cd /vagrant/.provision/ansible-playbooks
  git pull origin master
  source /usr/local/ansible/hacking/env-setup > /dev/null
  export ANSIBLE_HOST_KEY_CHECKING=False
  ansible-playbook ../playbooks/development.yml
  ansible-playbook ../playbooks/config.yml
fi

touch ~/.build-env/000