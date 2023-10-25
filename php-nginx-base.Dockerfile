FROM php:8.2-fpm-alpine

RUN \
    # deps
    apk add -U --no-cache --virtual temp \
    # dev deps
    autoconf g++ file re2c make zlib-dev oniguruma-dev \
    icu-data-full icu-dev libzip-dev libmemcached-dev \
    # prod deps
    && apk add --no-cache \
        nginx nodejs npm \
        zlib icu libzip git linux-headers libmemcached \
        freetype-dev libpng-dev jpeg-dev libjpeg-turbo-dev zip unzip supervisor \
    # php extensions
    && docker-php-source extract \
    && pecl channel-update pecl.php.net \
    && { php -m | grep gd || docker-php-ext-configure gd --with-freetype --with-jpeg --enable-gd; } \
    && docker-php-ext-install bcmath gd intl pcntl opcache pdo_mysql zip \
    && { pecl clear-cache || true; } \
    && pecl install memcached redis xdebug \
    && docker-php-source delete \
    #
    # composer
    && curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    # cleanup
    && apk del temp \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

RUN    ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# copy supervisor configuration
COPY ./.docker/backend/etc/supervisord.conf /etc/supervisord.conf

EXPOSE 80

# run supervisor
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
