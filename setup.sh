#!/bin/bash

echo "Setting up SLiMS Nginx Configuration..."

# Copy configuration to /etc/nginx/sites-available
sudo cp nginx/sites-available/slims /etc/nginx/sites-available/

# Create symlink to sites-enabled
sudo ln -sf /etc/nginx/sites-available/slims /etc/nginx/sites-enabled/slims

# Set permissions for SLiMS directory
sudo mkdir -p /var/www/html/slims
sudo cp -R www/html/slims/* /var/www/html/slims/
sudo chown -R www-data:www-data /var/www/html/slims
sudo chmod -R 755 /var/www/html/slims

# Test Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Reload Nginx
echo "Reloading Nginx..."
sudo systemctl reload nginx

echo "SLiMS setup completed!"
