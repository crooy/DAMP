FROM ubuntu:latest
MAINTAINER John Fink <john.fink@gmail.com>
RUN apt-get update # DATE Sat Aug 31 20:25:54 EDT 2013
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql php5-gd

#time for some security
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache-mod-security
ADD ./modsecurity.conf /etc/modsecurity/modsecurity.conf
RUN a2enmod headers
RUN a2enmod mod-security
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-evasive
ADD ./mod-evasive.conf /etc/apache2/mods-available/mod-evasive.conf
RUN a2enmod mod-evasive

RUN easy_install supervisor
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
EXPOSE 80
CMD ["/bin/bash", "/start.sh"]
