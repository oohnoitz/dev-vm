#!/bin/bash

mkdir -p /opt/deploy/workspace
cd /opt/deploy/workspace
apt-get install -y netselect-apt grep mawk
rm -rf /opt/deploy/workspace/sources.list
netselect-apt

if [ -f /opt/deploy/workspace/sources.list ] ; then
  APT_NEW=`cat /opt/deploy/workspace/sources.list | grep ^deb | awk '{print $2}' | head -1`
  APT_OLD=`cat /etc/apt/sources.list | grep ^deb | awk '{print $2}' | head -1`
  sed -i "s,${APT_OLD},${APT_NEW},g" /etc/apt/sources.list
  apt-get update
fi
