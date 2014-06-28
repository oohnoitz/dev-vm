Development VM
==============

This contains a collection of scripts used with Vagrant to provision a pre-configured development and testing environment. It was created to allow a small team of collaborators to work with one another in sync with very similar environments. It also allows collaborators to keep software versions in sync easily as well.

---

Environment:
 - Debian 7.5.0 (https://github.com/ffuenf/vagrant-boxes)
 - systemd

Software:
 - Ansible
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

#### Install
 1. `git clone https://github.com/oohnoitz/dev-vm.git`
 2. `cd dev-vm`
 3. `git submodule init`
 4. `git submodule update`
 5. `vagrant up`
 6. `vagrant reload --provision`

#### Update
 1. `git pull`
 2. `git submodule update`
 3. `vagrant reload --provision`
 