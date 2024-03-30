#!/bin/bash

# Define variables
DOMAIN="moealsir.tech"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"
NGINX_RELOAD="sudo systemctl restart nginx"

# Function to create Nginx configuration file for the subdomain
create_nginx_config() {
    SUBDOMAIN="$1"
    SUBDOMAIN_DIR="/var/www/$SUBDOMAIN.$DOMAIN/html"

    # Create directory for the subdomain
    sudo mkdir -p $SUBDOMAIN_DIR

    # Create index.html for testing purposes
    echo "<html><head><title>Welcome to $SUBDOMAIN</title></head><body><h1>Success! $SUBDOMAIN is working!</h1></body></html>" | sudo tee $SUBDOMAIN_DIR/index.html > /dev/null

    # Create Nginx configuration file
    sudo bash -c "cat > $NGINX_SITES_AVAILABLE/$SUBDOMAIN.$DOMAIN" <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name $SUBDOMAIN.$DOMAIN;

    root $SUBDOMAIN_DIR www.$SUBDOMAIN_DIR;
    index index.html index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

    # Create symbolic link to enable the site
    sudo ln -s $NGINX_SITES_AVAILABLE/$SUBDOMAIN.$DOMAIN $NGINX_SITES_ENABLED/$SUBDOMAIN.$DOMAIN
}

# Function to reload Nginx
reload_nginx() {
    $NGINX_RELOAD
}

# Main function
main() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <subdomain>"
        exit 1
    fi

    SUBDOMAIN="$1"

    # Create Nginx configuration
    create_nginx_config $SUBDOMAIN

    # Reload Nginx
    reload_nginx

    echo "Subdomain $SUBDOMAIN.$DOMAIN created successfully."
}

# Run main function with provided arguments
main "$@"

