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

  # install essentials and ansible dependencies
  apt-get install -y build-essential git libpcre3-dev libssl-dev unzip
  apt-get install -y python-yaml python-jinja2 python-paramiko sshpass

  # checkout ansible
  git clone https://github.com/ansible/ansible.git /usr/local/ansible
  cd /usr/local/ansible
  git checkout release1.8.2
  git submodule update --init --recursive

  # configure ansible
  mkdir -p /etc/ansible
  echo "localhost" > /etc/ansible/hosts
  echo "source /usr/local/ansible/hacking/env-setup > /dev/null" >> /root/.bashrc
  echo "source /usr/local/ansible/hacking/env-setup > /dev/null" >> /home/vagrant/.bashrc

  # configure ssh keys for ansible
  ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
fi

touch ~/.build-env/000

INSTALL=""
if [ -f /vagrant/.install ] ; then
  INSTALL="-t `paste -s -d ',' /vagrant/.install`"
fi

cd /vagrant/.provision/ansible-playbooks
git pull origin master
source /usr/local/ansible/hacking/env-setup > /dev/null
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook ../playbooks/development.yml ${INSTALL}
ansible-playbook ../playbooks/config.yml
