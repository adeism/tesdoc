FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    libzip-dev \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    git \
    && docker-php-ext-install pdo_mysql mbstring zip gd xml

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy SLiMS application files
COPY www/html/slims /var/www/html/slims

# Set permissions
RUN chown -R www-data:www-data /var/www/html/slims \
    && chmod -R 755 /var/www/html/slims

# Copy Nginx configuration
COPY nginx/slims.conf /etc/nginx/sites-available/slims
RUN ln -s /etc/nginx/sites-available/slims /etc/nginx/sites-enabled/

# Expose ports and set the default command
EXPOSE 80
CMD service php8.1-fpm start && nginx -g "daemon off;"
