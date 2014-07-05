#!/bin/bash

# this file is used to run certain commands after /vagrant has been mounted
if [ -f /bin/systemctl ] && [ -f /etc/systemd/system/nginx.service ] ; then
  /bin/systemctl restart nginx.service
fi

# run extra commands specified by the user
if [ -f /vagrant/start.sh ] ; then
  bash /vagrant/start.sh
fi