FROM nuagebec/ubuntu:14.04
MAINTAINER David Tremblay <david@nuagebec.ca>

#install php and apache

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y &&\
    apt-get -yq install \
	rsync \
        curl \
        apache2 \
        libapache2-mod-php5 \
        libapache2-mod-security2 \
        php5-mysql \
        php5-gd \
        php5-curl \
        php-pear \
	php5-mcrypt \
        php-mail \
        mysql-client \
        php5-intl \
	php-apc && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD supervisor_apache.conf /etc/supervisor/conf.d/apache.conf 
ADD ./config/php.ini /etc/php5/apache2/conf.d/php.ini
ADD ./config/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf


#Activate php5-mcrypt
RUN php5enmod mcrypt

#Activate opcache
RUN php5enmod opcache

#Activate mod_rewrite
RUN a2enmod rewrite

#activate mod_expires
RUN a2enmod expires

# activate intl
RUN php5enmod intl


RUN echo "<?php phpinfo();" > /var/www/html/index.php

# Add VOLUMEs to allow sharing logs and backup
VOLUME  ["/var/log/apache2", "/var/www/html"]


EXPOSE 80 443
CMD ["/data/run.sh"]

