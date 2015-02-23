FROM nuagebec/ubuntu:latest
MAINTAINER David Tremblay <david@nuagebec.ca>

#install php and apache
RUN apt-get update && \
    apt-get install -y apache2 php5 php5-gd php5-mysql php5-mcrypt php5-memcache php5-curl && \
    apt-get install -y wget curl   && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD supervisor_apache.conf /etc/supervisor/conf.d/apache.conf 
ADD ./config/php.ini /etc/php5/apache2/conf.d/php.ini
ADD ./config/000-default.conf /etc/apache2/sites-available/000-default.conf

#Activate php5-mcrypt
RUN php5enmod mcrypt

#Activate mod_rewrite
RUN a2enmod rewrite

RUN echo "<?php phpinfo();" > /var/www/html/index.php


EXPOSE 80 443
CMD ["/data/run.sh"]

