# Multi-stage build
FROM php:8.1-apache as slims_build

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip

# Clone SLiMS repository
WORKDIR /var/www/html
RUN git clone https://github.com/slims/slims9_bulian.git slims

# Configure Apache for SLiMS
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html/slims

# Second stage - WordPress
FROM wordpress:latest as wordpress

# Final stage - Combine both
FROM php:8.1-apache

# Copy PHP extensions and configurations from slims_build
COPY --from=slims_build /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=slims_build /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# Install required packages
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy SLiMS files
COPY --from=slims_build /var/www/html/slims /var/www/html/slims

# Copy WordPress files
COPY --from=wordpress /var/www/html /var/www/html/wordpress

# Configure Apache
RUN a2enmod rewrite
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Environment variables for WordPress
ENV WORDPRESS_DB_HOST=db \
    WORDPRESS_DB_USER=wordpress \
    WORDPRESS_DB_PASSWORD=wordpress_password \
    WORDPRESS_DB_NAME=wordpress

# Environment variables for SLiMS
ENV SLIMS_DB_HOST=db \
    SLIMS_DB_USER=slims \
    SLIMS_DB_PASSWORD=slims_password \
    SLIMS_DB_NAME=slims

EXPOSE 80

# Startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD ["/startup.sh"]
