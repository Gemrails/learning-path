FROM centos:latest
MAINTAINER Jason W <silentred3@gmail.com>
WORKDIR /tmp
RUN yum -y update

RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm; rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

#RUN yum -y groupinstall "Development Tools"
RUN systemctl stop firewalld; systemctl disable firewalld

RUN yum -y install php56w php56w-opcache php56w-cli php56w-common php56w-devel php56w-fpm php56w-gd  php56w-mbstring  php56w-mcrypt php56w-pdo php56w-mysqlnd php56w-pecl-xdebug php56w-pecl-memcache

#设置fpm，non-daemon 
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php.ini && \
    sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php.ini && \
	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf && \
    sed -i '/^listen = /c listen = 9000' /etc/php-fpm.d/www.conf && \
    sed -i '/^listen.allowed_clients/c ;listen.allowed_clients =' /etc/php-fpm.d/www.conf\
    # open short_tag
    sed -i 's/short_open_tag\s*=\s*Off/short_open_tag = On/' /etc/php.ini
	
RUN mkdir -p /data
VOLUME ["/data"]

EXPOSE 9000 22

ENTRYPOINT ["/usr/bin/php-fpm"]





