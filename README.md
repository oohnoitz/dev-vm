Development VM
==============

This contains a collection of scripts used with Vagrant to provision a pre-configured development and testing environment. It was created to allow a small team of collaborators to work with one another in sync with very similar environments. It also allows collaborators to keep software versions in sync easily as well.

---

Environment:
 - Debian 7.4.0 (https://github.com/ffuenf/vagrant-boxes)
 - systemd

Software:
 - Elasticsearch
 - ImageMagick
 - MySQL: MariaDB + TokuDB
 - MongoDB: TokuMX
 - Nginx
 - NodeJS
 - OpenJDK
 - PHP
 - Redis
 - Sphinx Search

Extras:
 - advancecomp
 - byobu
 - compass (Ruby)
 - git
 - htop
 - jpegoptim
 - ltrace
 - optipng
 - pngcrush
 - tmux
 - sass (Ruby)
 - screen
 - strace
 - unzip
 - zopfli

Instructions
------------

#### Install
 1. `git clone https://github.com/oohnoitz/dev-vm.git`
 2. `cd dev-vm`
 3. `git submodule init`
 4. `git submodule update`
 5. `vagrant up`
 6. `vagrant reload --provision`

#### Update
 1. `git pull`
 1. `git submodule update`
 2. `vagrant reload --provision`

Software
-----------

#### Elasticsearch
 - type: `binary`
 - location: `/usr/local/elasticsearch`
 - config: `/usr/local/elasticsearch/config/elasticsearch.yml`

#### MySQL: MariaDB + TokuDB
 - type: `binary`
 - location: `/usr/local/mysql`
 - config: `/etc/my.conf`

#### MongoDB: TokuMX
 - type: `binary`
 - location: `/usr/local/mongodb`
 - config: `/etc/mongodb.conf`

#### Nginx
 - type: `source`
 - configure: `--with-debug --with-ipv6 --with-http_realip_module --with-http_ssl_module --with-http_spdy_module --with-http_gzip_static_module --add-module=ngx_cache_purge`
 - location: `~`
 - config: `/usr/local/nginx/conf/nginx.conf`

#### NodeJS
 - type: `source`
 - location: `~`

#### OpenJDK
 - type: `apt`
 - configure: `none`
 - location: `~`

#### PHP
 - type: `source`
 - configure: `--enable-fpm --enable-zip --enable-sockets --with-pdo-mysql --with-mysqli --with-mysql --with-gettext --with-gd --enable-ftp --enable-exif --with-curl --with-bz2 --with-openssl --with-mcrypt --enable-mbstring --with-jpeg-dir --with-png-dir --with-zlib --enable-bcmath --enable-intl`
 - location: `~`
 - config: `/usr/local/lib/php.ini`, `/usr/local/etc/php-fpm.conf`

#### Redis
 - type: `source`
 - configure: `none`
 - location: `~`
 - config: `/etc/redis.conf`

#### Sphinx Search
 - type: `source`
 - configure: `--enable-id64`
 - location: `~`
 - config: `/usr/local/etc/sphinx.conf`
 