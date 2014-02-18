#!/bin/bash

if [ -f /bin/systemctl ] && [ -f /etc/systemd/system/nginx.service ] ; then
  sleep 5;
  /bin/systemctl restart nginx.service
fi
