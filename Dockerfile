# Docker SPIP
# Pour Debian Wheezy
#
# VERSION 0.0.6
#

FROM debian:wheezy
MAINTAINER cyp "cyp@rouquin.me"

ENV DEBIAN_FRONTEND noninteractive

# Depots, mises a jour et installs de Apache/PHP5

RUN echo "deb http://ftp.fr.debian.org/debian/ wheezy main non-free contrib" > /etc/apt/sources.list
RUN (apt-get update && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)
RUN apt-get install -y -q wget unzip vim ssh apache2 libapache2-mod-php5 php5-cli php5-mysql php5-gd php-pear php5-curl curl lynx-cur php5-xcache imagick php5-imagick netpbm && rm -rf /var/lib/apt/lists/*

# Configuration Apache

RUN a2enmod rewrite expires

# Installation de MySQL

RUN apt-get update -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove && apt-get install -y libaio1 pwgen && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
	&& rm -rf /var/lib/apt/lists/* \
	&& sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf \
	&& sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf \
	&& echo "mysqld_safe &" > /tmp/config \
	&& echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config \
	&& echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config \
	# && echo "mysql -e 'CREATE USER \"cyp\"@\"%\" IDENTIFIED BY \"123456789\";'" >> /tmp/config \
	&& bash /tmp/config \
	&& rm -f /tmp/config

# Installation et configuration de SPIP

RUN wget http://files.spip.org/spip/stable/spip-3.0.zip \
	&& unzip spip-3.0.zip \
	&& cp -a spip /var/www/ \
	&& rm -fr spip-3.0.zip \
	&& chmod 777 /var/www/spip/IMG \
	&& chmod 777 /var/www/spip/tmp \
	&& chmod 777 /var/www/spip/local \
	&& chmod 777 /var/www/spip/config \
	&& chown www-data:www-data -R /var/www/spip

COPY apache-config.conf /etc/apache2/sites-enabled/000-default

COPY start.sh /start.sh
COPY stop.sh /stop.sh
COPY apache/docker-entrypoint.sh /entrypoint-apache.sh
COPY mysql/docker-entrypoint.sh /entrypoint-mysql.sh

RUN chmod +x /start.sh \
	&& chmod +x /stop.sh \
	&& chmod +x /entrypoint-apache.sh \
	&& chmod +x /entrypoint-mysql.sh

ENTRYPOINT ["/entrypoint-apache.sh"]
ENTRYPOINT ["/entrypoint-mysql.sh"]

EXPOSE 80 3306

# Definition du répertoire à monter
VOLUME ["/etc/mysql", "/var/lib/mysql", "/var/www/spip"]

# Definition du répertoire de travail
# WORKDIR /var/www/spip

CMD ["apachectl"]
CMD ["mysqld"]
# CMD ["mysqld_safe"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
CMD ["/bin/bash"]
