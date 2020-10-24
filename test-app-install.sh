#!/bin/bash
set -e
#this script install most of the common unit testing phar and composer 
echo ${PWD}

/usr/bin/php7.3 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
/usr/bin/php7.3 composer-setup.php
/usr/bin/php7.3 -r "unlink('composer-setup.php');"

composer -V

wget -O phive https://phar.io/releases/phive.phar && chmod +x phive

yes | /usr/bin/php7.3 phive install --force-accept-unsigned --copy  #install most of the common things
/usr/bin/php7.3 phive install phpunit
ls -l tools


/usr/bin/php7.3 phive install --force-accept-unsigned --trust-gpg-keys phpcbf --copy
/usr/bin/php7.3 phive install --force-accept-unsigned --trust-gpg-keys php-cs-fixer --copy
/usr/bin/php7.3 phive install --force-accept-unsigned --trust-gpg-keys php-cs-fixer --copy
/usr/bin/php7.3 phive install --force-accept-unsigned --trust-gpg-keys composer-require-checker --copy
/usr/bin/php7.3 phive install --force-accept-unsigned --trust-gpg-keys phpab --copy
#Infection
#Infection requires a recent version of PHP, and XDebug, phpdbg, or pcov enabled.
/usr/bin/php7.3 phive install --force-accept-unsigned --trust-gpg-keys composer-require-checker infection --copy 

ls -l tools


#Error Tracing of code base via PSALM
composer require --dev vimeo/psalm
#Generate a config file and run: 
./vendor/bin/psalm --init && ./vendor/bin/psalm

#PHPBU Installer
wget -O tools/phpbu.phar https://phar.phpbu.de/phpbu.phar && chmod +x tools/phpbu.phar
/usr/bin/php7.3 tools/phpbu.phar --version


#PHPSTAN
wget -O tools/phpstan.phar https://github.com/phpstan/phpstan/releases/download/0.12.50/phpstan.phar && chmod +x tools/phpstan.phar
/usr/bin/php7.3 tools/phpstan.phar --version

#PHING
wget -O tools/phing.phar https://www.phing.info/get/phing-latest.phar && chmod +x tools/phing.phar
/usr/bin/php7.3 tools/phing.phar -version


#You compile Xdebug separately from the rest of PHP. You need access to the scripts phpize and php-config. If your system does not have phpize and php-config, you will need to install the PHP development headers.




