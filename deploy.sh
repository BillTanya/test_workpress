#!/bin/bash
set -e

# Source .env from both locations if they exist
if [ -f ".env" ]; then
    echo "File exists. Sourcing .env..."
    source .env
else
    echo ".env file does not exist."
fi

# Check if the word-press-key.pem file exists in the same directory as the script
if [ -f "word-press-key.pem" ]; then
    echo "File exists. Sourcing word-press-key.pem..."
else
    echo "word-press-key.pem file does not exist."
    exit 1
fi

echo "Set chmod ..."
chmod 400 "word-press-key.pem"

EC2_PUBLIC_IP_MODIFIED=$(echo "$EC2_PUBLIC_IP" | sed 's/\./-/g')

INSTANCE="ec2-$EC2_PUBLIC_IP_MODIFIED.$AWS_REGION.compute.amazonaws.com"
RDS_ENDPOINT_CLEAN=$(echo "$RDS_ENDPOINT" | sed 's/:.*//')

REMOTE_COMMANDS='
echo "Configure Apache for WordPress"
sudo tee /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    <Directory /var/www/html/>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

echo "Install WordPress"
cd /var/www/html
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo rm latest.tar.gz
sudo mv wordpress/* .
sudo rm -r wordpress
sudo rm index.html

echo "Copy and configure wp-config.php"
sudo cp wp-config-sample.php wp-config.php
sudo tee -a /var/www/html/wp-config.php <<EOF
define( "WP_REDIS_HOST", "'$REDIS_ENDPOINT'" );
define( "WP_REDIS_PORT", 6379 );
define( "WP_CACHE", true );
EOF

echo "Replace the values in wp-config.php"
sudo sed -i "s/database_name_here/'$TF_VAR_DB_NAME'/g" /var/www/html/wp-config.php
sudo sed -i "s/username_here/'$TF_VAR_RDS_USER_NAME'/g" /var/www/html/wp-config.php
sudo sed -i "s/password_here/'$TF_VAR_RDS_PASSWORD'/g" /var/www/html/wp-config.php
sudo sed -i "s/localhost/'$RDS_ENDPOINT_CLEAN'/g" /var/www/html/wp-config.php


echo "Set permissions"
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 777 /var/www/html

echo "Configure .htaccess"
sudo tee /var/www/html/.htaccess <<EOF
# BEGIN WordPress
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]

# Add a trailing slash to URLs
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
# END WordPress

EOF

echo "Restart Apache"
sudo systemctl restart apache2

echo "Connect to MySQL database and create the database"
mysql -h '$RDS_ENDPOINT_CLEAN' -u '$TF_VAR_RDS_USER_NAME' -p '$TF_VAR_RDS_PASSWORD' <<EOF
GRANT ALL PRIVILEGES ON '$TF_VAR_DB_NAME'.* TO '$TF_VAR_RDS_USER_NAME'@'%';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS '$TF_VAR_DB_NAME';
EOF


echo "Install WP-CLI (WordPress Command Line Interface)"
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo mv /var/www/html/wp-cli.phar /usr/local/bin/wp
sudo chmod +x /usr/local/bin/wp
sudo chmod -R 777 /var/www/html/wp-content

echo "Core install WordPress"
wp core install --url="http://'$EC2_PUBLIC_IP'" --title="Test Site Title" --admin_user="admin" --admin_password="'$SITE_PASSWORD'" --admin_email="test-word-press@gmail.com"

echo "Update site URL"
wp option update home "http://'$EC2_PUBLIC_IP'"
wp option update siteurl "http://'$EC2_PUBLIC_IP'"

echo "Install Redis plugin for WordPress"
wp plugin install redis-cache --activate

echo "Flush cache and enable Redis caching"
wp cache flush
wp redis enable

echo "Restart apache2 service"
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "Remove object-cache.php"
sudo rm wp-content/object-cache.php
'

echo "Executing commands on EC2 instance..."
ssh -o StrictHostKeyChecking=no -i "word-press-key.pem" "ubuntu@$INSTANCE" <<EOF
$REMOTE_COMMANDS
EOF

echo "Commands executed successfully."
