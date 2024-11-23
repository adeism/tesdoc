#!/bin/bash

# Wait for database
wait-for-it.sh $WORDPRESS_DB_HOST:3306 -t 60

# Configure WordPress
wp-config.php

# Configure SLiMS database connection
cat > /var/www/html/slims/config/database.php << EOF
<?php
\$dbs_host = getenv('SLIMS_DB_HOST');
\$dbs_username = getenv('SLIMS_DB_USER');
\$dbs_password = getenv('SLIMS_DB_PASSWORD');
\$dbs_name = getenv('SLIMS_DB_NAME');
EOF

# Start Apache
apache2-foreground
