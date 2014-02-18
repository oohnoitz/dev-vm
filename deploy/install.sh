#!/bin/bash

# This script will be used to provision our development environment in an orderly fashion. It
# will contain all essential software installations upon it's deployment.

if [[ $EUID -ne 0 ]] ; then
  echo "Error: This script must be run with root access to continue."
  exit 1
fi

# DOWNLOAD URLS
DOWN_MYSQL="http://www.tokutek.com/download.php?df=1&download_file=mariadb-5.5.30-tokudb-7.1.0-linux-x86_64.tar.gz"
DOWN_PHP55="http://php.net/distributions/php-5.5.9.tar.gz"
DOWN_REDIS="http://download.redis.io/releases/redis-2.8.5.tar.gz"
DOWN_MONGO="http://www.tokutek.com/download.php?df=1&download_file=tokumx-1.4.0-linux-x86_64-main.tar.gz"
DOWN_NODEJS="http://nodejs.org/dist/v0.10.25/node-v0.10.25.tar.gz"
DOWN_ZOPFLI="https://zopfli.googlecode.com/files/zopfli-1.0.0.zip"
DOWN_CASSANDRA="http://apache.mirrors.hoobly.com/cassandra/2.0.5/apache-cassandra-2.0.5-bin.tar.gz"
DOWN_IMAGEMAGICK="http://www.imagemagick.org/download/ImageMagick-6.8.8-5.tar.gz"
DOWN_SPHINXSEARCH="http://sphinxsearch.com/files/sphinx-2.1.5-release.tar.gz"
DOWN_ELASTICSEARCH="https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.0.tar.gz"

# PATHS
PATH_SOURCE="/vagrant/.src"
PATH_NGINX="${PATH_SOURCE}/nginx/1.5.10.dat"
PATH_MYSQL="${PATH_SOURCE}/$(basename ${DOWN_MYSQL} | sed -e 's,download.php?df=1&download_file=,,g')"
PATH_PHP55="${PATH_SOURCE}/$(basename ${DOWN_PHP55})"
PATH_REDIS="${PATH_SOURCE}/$(basename ${DOWN_REDIS})"
PATH_MONGO="${PATH_SOURCE}/$(basename ${DOWN_MONGO} | sed -e 's,download.php?df=1&download_file=,,g')"
PATH_NODEJS="${PATH_SOURCE}/$(basename ${DOWN_NODEJS})"
PATH_ZOPFLI="${PATH_SOURCE}/$(basename ${DOWN_ZOPFLI})"
PATH_CASSANDRA="${PATH_SOURCE}/$(basename ${DOWN_CASSANDRA})"
PATH_IMAGEMAGICK="${PATH_SOURCE}/$(basename ${DOWN_IMAGEMAGICK})"
PATH_SPHINXSEARCH="${PATH_SOURCE}/$(basename ${DOWN_SPHINXSEARCH})"
PATH_ELASTICSEARCH="${PATH_SOURCE}/$(basename ${DOWN_ELASTICSEARCH})"

# INIT
mkdir -p /opt/deploy/workspace
mkdir -p ${PATH_SOURCE}
mkdir -p ${PATH_SOURCE}/nginx
chmod +x /vagrant/deploy/config.sh

# APT
apt-get update
apt-get install -y git autoconf
apt-get install -y htop strace ltrace tmux byobu
apt-get install -y optipng advancecomp pngcrush jpegoptim
apt-get install -y ruby-compass ruby-sass
apt-get install -y openjdk-7-jdk

# FUNCTION
function reload() {
  cp /vagrant/deploy/service/${1} /etc/systemd/system/${1}
  /bin/systemctl --system daemon-reload
  /bin/systemctl enable ${1}
  /bin/systemctl restart ${1}
  /bin/systemctl status ${1}
}

if [ ! -f ${PATH_NGINX} ]
then
  cd /opt/deploy/workspace
  cp /vagrant/deploy/lib/nginx-installer/install-nginx.sh /opt/deploy/install-nginx
  cp /vagrant/deploy/lib/nginx-installer/install-module.sh /opt/deploy/install-nginx-module
  chmod +x /opt/deploy/install-nginx*
  /opt/deploy/install-nginx-module ngx_cache_purge
  /opt/deploy/install-nginx $(basename ${PATH_NGINX} ".dat")
  touch ${PATH_NGINX}
  mkdir -p /usr/local/nginx/conf/ssl
  cp /vagrant/deploy/ssl/default.crt /usr/local/nginx/conf/ssl/default.crt
  cp /vagrant/deploy/ssl/default.key /usr/local/nginx/conf/ssl/default.key
  cp /vagrant/deploy/udev/50-vagrant-mount.rules /etc/udev/rules.d/50-vagrant-mount.rules
  cp /vagrant/deploy/udev.sh /opt/deploy/udev.sh
  chmod +x /opt/deploy/udev.sh
  bash -x /vagrant/deploy/config.sh nginx no
  reload nginx.service
fi

if [ ! -f ${PATH_MYSQL} ]
then
  apt-get install -y libaio-dev
  cd /opt/deploy/workspace
  wget -nc ${DOWN_MYSQL} -O ${PATH_MYSQL}
  tar zxvf ${PATH_MYSQL}
  rm -rf /usr/local/mysql
  mv /opt/deploy/workspace/$(basename ${PATH_MYSQL} ".tar.gz") /usr/local/mysql
  cd /usr/local/mysql
  if [ ! -f ~/.deploy/init-mysql-000 ]
  then
    groupadd mysql
    useradd -r -g mysql mysql
    touch ~/.deploy/init-mysql-000
  fi
  chown -R mysql .
  chgrp -R mysql .
  mkdir -p /var/data/mysql/data
  if [ ! -f ~/.deploy/init-mysql-001 ]
  then
    scripts/mysql_install_db --user=mysql --datadir=/var/data/mysql/data
    touch ~/.deploy/init-mysql-001
  fi
  chown -R root .
  chown -R mysql data
  chgrp -R mysql /var/data/mysql
  bash -x /vagrant/deploy/config.sh mysql no
  reload mysqld.service
fi

if [ ! -f ${PATH_PHP55} ]
then
  apt-get install -y libbz2-dev libcurl4-openssl-dev libxml2-dev libjpeg-dev libpng-dev libtiff-dev libmcrypt-dev locales-all libicu-dev
  cd /opt/deploy/workspace
  wget -nc ${DOWN_PHP55} -O ${PATH_PHP55}
  tar zxvf ${PATH_PHP55}
  cd /opt/deploy/workspace/$(basename ${PATH_PHP55} ".tar.gz")
  ./configure --enable-fpm --enable-zip --enable-sockets --with-pdo-mysql --with-mysqli --with-mysql --with-gettext --with-gd --enable-ftp --enable-exif --with-curl --with-bz2 --with-openssl --with-mcrypt --enable-mbstring --with-jpeg-dir --with-png-dir --with-zlib --enable-bcmath --enable-intl
  make && make install
  bash -x /vagrant/deploy/config.sh php no
  reload php-fpm.service
fi

if [ ! -f ${PATH_REDIS} ]
then
  cd /opt/deploy/workspace
  wget -nc ${DOWN_REDIS} -O ${PATH_REDIS}
  tar zxvf ${PATH_REDIS}
  cd /opt/deploy/workspace/$(basename ${PATH_REDIS} ".tar.gz")
  make && make install
  bash -x /vagrant/deploy/config.sh redis no
  reload redis.service
fi

if [ ! -f ${PATH_MONGO} ]
then
  cd /opt/deploy/workspace
  wget -nc ${DOWN_MONGO} -O ${PATH_MONGO}
  tar zxvf ${PATH_MONGO}
  rm -rf /usr/local/mongodb
  mv /opt/deploy/workspace/$(basename ${PATH_MONGO} "-main.tar.gz") /usr/local/mongodb
  mkdir -p /var/data/mongodb
  mkdir -p /var/log/mongodb
  chown -R vagrant:vagrant /var/data/mongodb
  chown -R vagrant:vagrant /var/log/mongodb
  bash -x /vagrant/deploy/config.sh mongodb no
  reload mongodb.service
fi

if [ ! -f ${PATH_NODEJS} ]
then
  cd /opt/deploy/workspace
  wget -nc ${DOWN_NODEJS} -O ${PATH_NODEJS}
  tar zxvf ${PATH_NODEJS}
  cd /opt/deploy/workspace/$(basename ${PATH_NODEJS} ".tar.gz")
  ./configure
  make && make install
fi

if [ ! -f ${PATH_ZOPFLI} ]
then
  apt-get install -y unzip
  cd /opt/deploy/workspace
  wget -nc ${DOWN_ZOPFLI} -O ${PATH_ZOPFLI}
  unzip -o ${PATH_ZOPFLI}
  cd $(basename ${PATH_ZOPFLI} ".zip")
  make
  cp /opt/deploy/workspace/$(basename ${PATH_ZOPFLI} ".zip") /usr/local/bin/zopfli
fi

if [ ! -f ${PATH_CASSANDRA} ]
then
  cd /opt/deploy/workspace
  wget -nc ${DOWN_CASSANDRA} -O ${PATH_CASSANDRA}
  tar zxvf ${PATH_CASSANDRA}
  rm -rf /usr/local/cassandra
  mv /opt/deploy/workspace/$(basename ${PATH_CASSANDRA} ".tar.gz") /usr/local/cassandra
fi

if [ ! -f ${PATH_IMAGEMAGICK} ]
then
  cd /opt/deploy/workspace
  wget -nc ${DOWN_IMAGEMAGICK} -O ${PATH_IMAGEMAGICK}
  tar zxvf ${PATH_IMAGEMAGICK}
  cd $(basename ${PATH_IMAGEMAGICK} ".tar.gz")
  ./configure
  make && make install
fi

if [ ! -f ${PATH_SPHINXSEARCH} ]
then
  cd /opt/deploy/workspace
  wget -nc ${DOWN_SPHINXSEARCH} -O ${PATH_SPHINXSEARCH}
  tar zxvf ${PATH_SPHINXSEARCH}
  cd $(basename ${PATH_SPHINXSEARCH} ".tar.gz")
  ./configure --enable-id64
  make && make install
fi

if [ ! -f ${PATH_ELASTICSEARCH} ]
then
  cd /opt/deploy/workspace
  wget -nc ${DOWN_ELASTICSEARCH} -O ${PATH_ELASTICSEARCH}
  tar zxvf ${PATH_ELASTICSEARCH}
  rm -rf /usr/local/elasticsearch
  mv /opt/deploy/workspace/$(basename ${PATH_ELASTICSEARCH} ".tar.gz") /usr/local/elasticsearch
  mkdir -p /var/data/elasticsearch
  mkdir -p /var/log/elasticsearch
  mkdir -p /var/run/elasticsearch
  chown -R vagrant:vagrant /var/data/elasticsearch
  chown -R vagrant:vagrant /var/log/elasticsearch
  chown -R vagrant:vagrant /var/run/elasticsearch
  bash -x /vagrant/deploy/config.sh elasticsearch no
  reload elasticsearch.service
fi

if [ ! -f ~/.deploy/init-pgsql-000 ]
then
  echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" >> /etc/apt/sources.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  apt-get update
  apt-get -y upgrade
  apt-get install -y postgresql postgresql-client
  touch ~/.deploy/init-pgsql-000
fi
