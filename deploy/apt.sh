#!/bin/bash

mkdir -p /opt/deploy/workspace
cd /opt/deploy/workspace
apt-get install -y netselect-apt grep mawk
rm -rf /opt/deploy/workspace/apt-mirrors

tr '\n' ' ' < /vagrant/deploy/etc/apt-mirrors > /opt/deploy/workspace/apt-mirrors
APT_NEW=`netselect -s 1 -vv $(cat /opt/deploy/workspace/apt-mirrors) | awk '{print $2}' | head -1`
APT_OLD=`cat /etc/apt/sources.list | grep ^deb | awk '{print $2}' | head -1`
sed -i "s,${APT_OLD},${APT_NEW},g" /etc/apt/sources.list
apt-get update
