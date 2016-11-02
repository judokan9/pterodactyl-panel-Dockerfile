FROM alpine:3.4

LABEL version="latest"

MAINTAINER Michael Parker, <parker@parkervcp.com>

RUN echo http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
 && echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
 && echo http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
 && apk update \
 && apk add openssl-dev nginx php7 php7-bcmath php7-common php7-dom php7-fpm php7-gd php7-mbstring php7-openssl php7-pdo php7-phar php7-json php7-pdo_mysql php7-session php7-ctype supervisor git \
 && mv /usr/bin/php7 /usr/bin/php \
 && mv /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
 && mkdir /etc/nginx/sites-available \
 && mkdir -p /run/nginx \
 && touch /run/nginx/nginx.pid \
 && sed -i '1idaemon off;' /etc/nginx/nginx.conf \
 && sed -i -e 's,;daemonize = yes,daemonize = no,g' /etc/php7/php-fpm.conf

COPY ./manifest/ /

WORKDIR /var/www/html/

RUN chmod +x /var/www/html/entrypoint.sh \
 && apk add curl tar \
 && git init \
 && git remote add origin https://github.com/Pterodactyl/Panel.git \
 && git fetch \
 && git checkout -t origin/develop \
 && chown -R nginx:nginx * \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && composer install --ansi --no-dev

ENTRYPOINT ["/var/www/html/entrypoint.sh"]

EXPOSE 80

CMD ["supervisord", "-n"]
