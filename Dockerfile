FROM php:7.4-apache
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install libapache2-mod-auth-mellon
# RUN apt -y install libapache2-mod-security2

RUN a2enmod proxy_http proxy ssl rewrite auth_mellon headers socache_shmcb
