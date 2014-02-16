#!/bin/bash

if [[ $EUID -ne 0 ]] ; then
  echo "Error: This script must be run with root access to continue."
  exit 1
fi

function reload_conf() {
  if [ -f "/etc/systemd/system/${1}" ] && [ "${2}" == "yes" ] ; then
    /bin/systemctl --system daemon-reload
    /bin/systemctl restart ${1}
    /bin/systemctl status ${1}
  fi
}

function update_conf() {
  CONF="${1}"
  if [ -d "/vagrant/.config" ] && [ -f "/vagrant/.config/$(basename ${1})" ] ; then
    CONF="/vagrant/.config/$(basename ${1})"
  fi

  if [ -f ${CONF} ] ; then
    cp -u ${CONF} ${2}
  fi
}

function process() {
  RELOAD=${2}
  if [ "${RELOAD}" == "" ] ; then
    RELOAD="yes"
  fi

  case "${1}" in
    elasticsearch)
      update_conf /vagrant/deploy/config/elasticsearch.yml /usr/local/elasticsearch/config/elasticsearch.yml
      reload_conf elasticsearch.service ${RELOAD}
      ;;
    mongodb)
      update_conf /vagrant/deploy/config/mongodb.conf /etc/mongodb.conf
      reload_conf mongodb.service ${RELOAD}
      ;;
    mysql)
      update_conf /vagrant/deploy/config/mysql.cnf /etc/my.cnf
      reload_conf mysqld.service ${RELOAD}
      ;;
    nginx)
      update_conf /vagrant/deploy/config/nginx.conf /usr/local/nginx/conf/nginx.conf
      update_conf /vagrant/deploy/config/nginx.type /usr/local/nginx/conf/mime.types
      reload_conf nginx.service ${RELOAD}
      ;;
    php)
      update_conf /vagrant/deploy/config/php.ini /usr/local/lib/php.ini
      update_conf /vagrant/deploy/config/php-fpm.conf /usr/local/etc/php-fpm.conf
      reload_conf php-fpm.service ${RELOAD}
      ;;
    redis)
      update_conf /opt/deploy/workspace/redis-*/redis.conf /etc/redis.conf
      reload_conf redis.service ${RELOAD}
      ;;

    *)
      echo "Error: Invalid Config"
      exit 1
      ;;
  esac
}

process ${1} ${2}
