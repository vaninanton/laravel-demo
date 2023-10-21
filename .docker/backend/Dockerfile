# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM vaninanton/gocpa-php:sha-3d2f9e3
RUN apk add npm nginx

COPY .docker/nginx/conf.d/default.conf /etc/nginx/http.d/default.conf
COPY entrypoint.sh /etc/entrypoint.sh

COPY --chown=www-data:www-data . /var/www/html
WORKDIR /var/www/html

# RUN composer install --no-interaction --optimize-autoloader --no-dev
# RUN npm install && npm run build
# RUN php artisan optimize

EXPOSE 80 443
ENTRYPOINT ["/etc/entrypoint.sh"]
