#!/bin/bash
echo This one was working and last tested for debian 9 on AWS EC2, 2019-11-11
echo Please run as root!
read -p "Type anything to Continue .. crl+c to abort"  abortchar

# uncomment if desired
#/usr/bin/apt-get install python3-certbot-apache
#/usr/bin/apt-get install php7.0 apache2 mariadb-server
#/usr/bin/apt-get install phpmyadmin

echo Enable Headers Module to use "Header set"
/usr/sbin/a2enmod headers
echo Disable Status Module to prevent Info Disclosure
/usr/sbin/a2dismod status 
echo Restart Apache
/bin/systemctl restart apache2

echo Change config to prevent info disclosure
sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf
sed -i 's/ServerTokens OS/ServerTokens Prod/g' /etc/apache2/conf-enabled/security.conf

echo Remove Alias from config
sed -i 's/Alias \/icons\/ "\/usr\/share\/apache2\/icons\/"/#Alias \/icons\/ "\/usr\/share\/apache2\/icons\/"/g'  /etc/apache2/mods-enabled/alias.conf
rm -rf /usr/share/apache2/icons/

echo Change config to use basic security header 
sed -i 's/#Header set X-Content-Type-Options: "nosniff"/Header set X-Content-Type-Options: "nosniff"/g' /etc/apache2/conf-enabled/security.conf
sed -i 's/#Header set X-Frame-Options: "sameorigin"/Header set X-Frame-Options: "sameorigin"/g' /etc/apache2/conf-enabled/security.conf

echo Add additional HTTP-Security-Header
echo 'Header set X-XSS-Protection: "1; mode=block"' >> /etc/apache2/conf-enabled/security.conf
echo 'Header set Referrer-Policy "origin-when-cross-origin"' >> /etc/apache2/conf-enabled/security.conf

echo Change PHP-config to prevent Info Disclosure
sed -i 's/expose_php = On/expose_php = Off/g' /etc/php/7.0/apache2/php.ini

echo Change PHP-config to use basic security advises
sed -i 's/;session.cookie_secure =/session.cookie_secure = 1/g' /etc/php/7.0/apache2/php.ini
sed -i 's/session.cookie_httponly =/session.cookie_httponly = 1/g' /etc/php/7.0/apache2/php.ini

echo Disable default site
/usr/sbin/a2dissite 000-default.conf 

echo Remove default index and create empty one
rm /var/www/html/index.html
touch /var/www/html/index.html 
chown www-data:www-data /var/www/html/index.html 

echo Restart Apache
/bin/systemctl restart apache2

echo Now create your own specific listener as desired

# certbot /Let's encrypt: Denkt an den CronJob
## 1 8 * * * /usr/bin/certbot renew 2>&1
