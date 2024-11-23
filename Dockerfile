# Base image
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

# Create SLiMS application folder and add a placeholder
RUN mkdir -p /var/www/html/slims \
    && echo "<?php echo 'Welcome to SLiMS!'; ?>" > /var/www/html/slims/index.php

# Set permissions
RUN chown -R www-data:www-data /var/www/html/slims \
    && chmod -R 755 /var/www/html/slims

# Copy nginx configuration
COPY nginx/slims.conf /etc/nginx/sites-available/slims.conf
RUN ln -s /etc/nginx/sites-available/slims.conf /etc/nginx/sites-enabled/

# Start services
CMD ["php-fpm", "-F"]
