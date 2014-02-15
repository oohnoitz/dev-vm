#!/bin/bash

if [ ! -f ~/.deploy/init-php-000 ]
then
  cd /opt/deploy/workspace
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin
  mv /usr/local/bin/composer.phar /usr/local/bin/composer
  wget -N https://phar.phpunit.de/phpunit.phar
  cp /opt/deploy/workspace/phpunit.phar /usr/local/bin/phpunit
  chmod +x /usr/local/bin/phpunit
  wget -N http://static.pdepend.org/php/latest/pdepend.phar
  cp /opt/deploy/workspace/pdepend.phar /usr/local/bin/pdepend
  chmod +x /usr/local/bin/pdepend
  wget -N https://phar.phpunit.de/phpcpd.phar
  cp /opt/deploy/workspace/phpcpd.phar /usr/local/bin/phpcpd
  chmod +x /usr/local/bin/phpcpd
fi