FROM alpine:3.5

MAINTAINER Michael Parker, <parker@parkervcp.com>

RUN apk update \
 && apk add openssl-dev php7 php7-bcmath php7-common php7-dom php7-fpm php7-gd php7-mbstring php7-openssl php7-pdo php7-phar php7-json php7-pdo_mysql php7-session php7-ctype curl tar tini caddy zip unzip \
 && mv /usr/bin/php7 /usr/bin/php \
 && mv /usr/sbin/php-fpm7 /usr/sbin/php-fpm

COPY ./manifest/ /

WORKDIR /var/www/

RUN curl -Lo develop.zip https://github.com/Pterodactyl/Panel/archive/develop.zip \
 && unzip develop.zip \
 && mv Panel-develop/* html/ \
 && rm -rf Panel-develop/ \
 && rm develop.zip \
 && chown -R caddy:caddy * \
 && chmod -R 777 storage/* bootstrap/cache \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && composer install --ansi --no-dev

WORKDIR /var/www/html/

ENTRYPOINT ["/bin/ash", "/var/www/html/entrypoint.sh"]

EXPOSE 80

CMD ["/sbin/tini", "--", "/usr/sbin/caddy", "-conf", "/etc/caddy/caddy.conf"]