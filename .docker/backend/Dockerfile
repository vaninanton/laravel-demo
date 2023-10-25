FROM --platform=$TARGETPLATFORM vaninanton/php-nginx-base:latest

# set composer related environment variables
ENV COMPOSER_ALLOW_SUPERUSER=1

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG APP_VERSION

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# add custom php-fpm pool settings, these get written at entrypoint startup
ENV FPM_PM_MAX_CHILDREN=20 \
    FPM_PM_START_SERVERS=2 \
    FPM_PM_MIN_SPARE_SERVERS=1 \
    FPM_PM_MAX_SPARE_SERVERS=3

# set application environment variables
ENV APP_NAME="Question Board" \
    APP_ENV=production \
    APP_DEBUG=false

# copy entrypoint files
COPY ./.docker/docker-php-* /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-entrypoint
RUN chmod +x /usr/local/bin/docker-php-entrypoint-dev

# copy nginx configuration
COPY ./.docker/backend/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./.docker/backend/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# install application dependencies
WORKDIR /var/www/html
COPY --chown=www-data:www-data . .

RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
RUN composer install --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist --no-dev
RUN npm install
RUN npm run build
RUN php artisan optimize

EXPOSE 80

# run supervisor
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
