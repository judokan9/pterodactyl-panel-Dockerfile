FROM centos:7

MAINTAINER Michael Parker, <parker@parkervcp.com>

WORKDIR /var/www/html/

COPY entrypoint.sh .

RUN yum install -y epel-release http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
 && yum --enablerepo=remi install -y httpd openssl-devel php70-php php70-php-common php70-php-fpm php70-php-cli php70-php-mysql \
    php70-php-mcrypt php70-php-gd php70-php-mbstring php70-php-pdo php70-php-zip php70-php-bcmath php70-php-dom php70-php-opcache \
 && source /opt/remi/php70/enable \
 && curl -Lo v0.5.0-pre.3.tar.gz https://github.com/Pterodactyl/Panel/archive/v0.5.0-pre.3.tar.gz \
 && tar --strip-components=1 -xzvf v0.5.0-pre.3.tar.gz \
 && chmod -R 777 storage/* bootstrap/cache \
 && chown -R apache:apache * \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && composer install --ansi --no-dev \
 && sed -i -e 's,DocumentRoot "/var/www/html",DocumentRoot "/var/www/html/public",g' /etc/httpd/conf/httpd.conf \
 && sed -i -e 's,AllowOverride None,AllowOverride All,g' /etc/httpd/conf/httpd.conf \
 && sed -i -e 's,AllowOverride none,AllowOverride All,g' /etc/httpd/conf/httpd.conf \
 && sed -i -e 's,DirectoryIndex index.html,DirectoryIndex index.php,g' /etc/httpd/conf/httpd.conf \
 && chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 80
CMD ["httpd", "-DFOREGROUND"]