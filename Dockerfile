FROM php:8.1-fpm-alpine

# Install dependencies
RUN apk add --no-cache nginx mariadb supervisor curl bash libpng-dev gettext-dev oniguruma-dev libjpeg-turbo-dev libwebp-dev libxpm-dev freetype-dev

# Configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install gd gettext mbstring mysqli pdo pdo_mysql

# Copy configuration files
COPY default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Verify Nginx configuration
RUN nginx -t

# Set working directory
WORKDIR /var/www/html

# Expose necessary ports
EXPOSE 80

# Use Supervisor to manage processes
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
