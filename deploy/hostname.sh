#!/bin/bash

host=`hostname`
name=`shuf -n 1 /vagrant/deploy/etc/hostname`

[ -f /etc/exim4/update-exim4.conf.conf ] && sed -i "s,${host}.vagrantup.com,${name}.dev,g" /etc/exim4/update-exim4.conf.conf
[ -f /etc/hosts ] && sed -i "s,${host}.vagrantup.com,${name}.dev,g" /etc/hosts

for file in \
  /etc/hosts \
  /etc/hostname \
  /etc/ssh/ssh_host_rsa_key.pub \
  /etc/ssh/ssh_host_dsa_key.pub
do
  [ -f $file ] && sed -i "s,${host},${name},g" $file
done

hostname $name
