Development VM
==============

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

### Install
 1. `git clone https://github.com/oohnoitz/dev-vm.git`
 2. `git submodule init`
 3. `git submodule update`
 4. `vagrant up`
 5. `vagrant reload --provision`

### Update
 1. `git pull`
 1. `git submodule update`
 2. `vagrant reload --provision`
 