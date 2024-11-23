FROM php:8.1-fpm-alpine

# Install nginx, PHP extensions, dan library sistem
RUN apk add --no-cache \
    nginx mariadb supervisor curl bash libpng-dev gettext-dev \
    oniguruma-dev libjpeg-turbo-dev libwebp-dev libxpm-dev freetype-dev

# Konfigurasi PHP GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd gettext mbstring mysqli pdo pdo_mysql

# Copy konfigurasi Nginx
COPY ./nginx.conf /etc/nginx/nginx.conf

# Verifikasi konfigurasi Nginx
RUN nginx -t

# Konfigurasi Supervisor untuk menjalankan Nginx dan PHP-FPM
COPY ./supervisord.conf /etc/supervisord.conf

# Expose port dan entrypoint
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
