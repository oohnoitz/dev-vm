Development VM
==============

Environment:
 - Debian 7.4.0 (https://github.com/ffuenf/vagrant-boxes)
 - systemd

Software:
 - Elasticsearch
 - ImageMagick
 - MySQL: MariaDB + TokuDB
 - MongoDB: TokuDB
 - Nginx
 - NodeJS
 - PHP
 - Redis
 - Sphinx Search
 - Zopfli

Extras:
 - advancecomp
 - compass (Ruby)
 - git
 - htop
 - jpegoptim
 - ltrace
 - optipng
 - pngcrush
 - strace
 - sass (Ruby)
 - unzip

Instructions
------------
 - `git clone https://github.com/oohnoitz/dev-vm.git`
 - `git submodule init`
 - `git submodule update`
 - `vagrant up`
 - `vagrant reload --provision`