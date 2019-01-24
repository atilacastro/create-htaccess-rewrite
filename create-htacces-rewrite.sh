#!/bin/bash

# This script create a file .htaccess in a secific directory
# and write inside it with a Rewrite Condition that rewrite a specific path with https.
# Author: Atila Castro
# Date 23/01/2019

# Usage: . create-htaccess-rewrite.sh $CLIENTE $PRODUCT (Eg.: . create-htaccess-rewrite.sh corp callcenter )

# Variables
CLIENTE=$1
PRODUCT=$2
DIR="/var/www/teknisa/$1/$2/mobile"

#This function add rewrite condition in a .htacces file
function rewrite () {
    cd $DIR
    touch .htaccess

    echo "
RewriteEngine On
RewriteCond %{HTTP:X-Forwarded-Proto} =http
RewriteCond %{REQUEST_URI} $CLIENTE
RewriteRule ^(.*)$ https://$PRODUCT.teknisa.cloud/$CLIENTE/\$1 [L,R=permanent] " >> .htaccess
}

# This function check the apache, reload it and print status
function apache_service() {
    echo "Checking Apache Config, if OK Reloaded..."
    apache2ctl configtest && /etc/init.d/apache2 reload
    /etc/init.d/apache2 status
}
# Call Functions
rewrite
apache_service
# Print screen with a .htaccess content
cat .htaccess
