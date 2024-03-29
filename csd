#!/bin/bash

##########################################################################
#						  	 		                                    #
# 	create a sub domain                                              #
#									                                       #
#	echo "Usage: $0 <subdomain>                                         #
#									                                    #
##########################################################################



# Define variables
DOMAIN="moealsir.tech"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"
NGINX_RELOAD="sudo systemctl reload nginx"

# Function to create a new subdomain
create_subdomain() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <subdomain>"
        exit 1
    fi

    SUBDOMAIN="$1"

    # Create subdomain folder by copying the main domain folder
    sudo cp -r "/var/www/$DOMAIN" "/var/www/$SUBDOMAIN.$DOMAIN"

    # Create Nginx configuration file for the subdomain
    sudo tee "/etc/nginx/sites-available/$SUBDOMAIN.$DOMAIN" > /dev/null <<EOF
server {
    listen 80;
    root /var/www/$SUBDOMAIN.$DOMAIN;
    index index.html index.htm index.nginx-debian.html;
    server_name $SUBDOMAIN.$DOMAIN www.$SUBDOMAIN.$DOMAIN;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

    # Create symbolic link to enable the site
    sudo ln -s "/etc/nginx/sites-available/$SUBDOMAIN.$DOMAIN" "/etc/nginx/sites-enabled/$SUBDOMAIN.$DOMAIN"

    # Adjust permissions
    sudo chown -R $USER:$USER "/var/www/$DOMAIN/html"
    sudo chown -R $USER:$USER "/var/www/$SUBDOMAIN.$DOMAIN/html"
    sudo chmod -R 755 "/var/www/$DOMAIN"
    sudo chmod -R 755 "/var/www/$SUBDOMAIN.$DOMAIN"

    # Reload Nginx
    $NGINX_RELOAD

    echo "Subdomain $SUBDOMAIN.$DOMAIN created successfully."
}

# Run the function with provided arguments
create_subdomain "$@"
