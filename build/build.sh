#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive
export TERM=linux

# init packages
apt update

apt -y install apt-transport-https lsb-release ca-certificates curl wget
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

sed -i "s|deb http://deb.debian.org/debian bullseye main|deb http://deb.debian.org/debian bullseye backports main contrib|" /etc/apt/sources.list
sed -i "s|deb deb http://security.debian.org/debian-security bullseye-security main|deb http://security.debian.org/debian-security bullseye-security main contrib|" /etc/apt/sources.list
sed -i "s|deb http://deb.debian.org/debian bullseye-updates main|deb http://deb.debian.org/debian bullseye-updates main contrib|" /etc/apt/sources.list

sh -c 'echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list'

apt update
apt upgrade -y

apt install -y \
  cron \
  curl \
  libapache2-mod-php${PHP_VERSION} \
  locales \
  php${PHP_VERSION} \
  php${PHP_VERSION}-common \
  php${PHP_VERSION}-curl \
  php${PHP_VERSION}-intl \
  php${PHP_VERSION}-mysql \
  php${PHP_VERSION}-opcache \
  php${PHP_VERSION}-xml \
  php${PHP_VERSION}-zip \
  rsyslog \
  sphinxsearch \
  sudo \
  supervisor \
  unzip \
  wget

update-alternatives --set php /usr/bin/php${PHP_VERSION}

# docker-template compatibility
ln -s /usr/bin/php /usr/local/bin/php

# Hide errors
echo "display_errors=off" > /etc/php/${PHP_VERSION}/mods-available/errors.ini
echo "log_errors=on" >> /etc/php/${PHP_VERSION}/mods-available/errors.ini
phpenmod errors

# apache enable .htaccess
echo "<Directory /var/www/html>" > /etc/apache2/conf-available/enable-htaccess.conf
echo "    AllowOverride All" >> /etc/apache2/conf-available/enable-htaccess.conf
echo "</Directory>" >> /etc/apache2/conf-available/enable-htaccess.conf
a2enconf enable-htaccess

# apache enable modules
a2enmod rewrite
a2enmod headers
a2enmod expires
a2enmod proxy
a2enmod proxy_http

# locales
LOCALES="en_US en_GB fr_FR es_ES pt_PT de_DE"
for L in $LOCALES; do
    localedef -i $L -c -f UTF-8 -A /etc/locale.alias $L.UTF-8
done

# Set the time zone to the local time zone
echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
echo "date.timezone = Europe/Berlin" > /etc/php/${PHP_VERSION}/mods-available/timezone.ini
phpenmod timezone

# rsyslog
sed -i "s/module(load=\"imklog\")/#module(load=\"imklog\")/" /etc/rsyslog.conf

# cleanup
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*

exit 0
