#!/bin/bash

# Function to create a path for the main domain
create_main_domain_path() {
    path_name=$1

    # Create the directory for the main domain
    sudo mkdir -p "/var/www/moealsir.tech/$path_name"

    # Adjust permissions if needed
    sudo chown -R www-data:www-data "/var/www/moealsir.tech/$path_name"
    sudo chmod -R 755 "/var/www/moealsir.tech/$path_name"

    # Create a test index.html file
    sudo sh -c "echo '<html><head><title>Welcome to moealsir.tech</title></head><body><h1>Success! The path $path_name has been created for moealsir.tech</h1></body></html>' > /var/www/moealsir.tech$path_name/index.html"

    # Inform user about completion
    echo "Path created successfully for the main domain."
}

# Function to create a path for a subdomain
create_subdomain_path() {
    subdomain=$1
    path_name=$2

    # Create the directory for the subdomain
    sudo mkdir -p "/var/www/$subdomain.moealsir.tech/$path_name"

    # Adjust permissions if needed
    sudo chown -R www-data:www-data "/var/www/$subdomain.moealsir.tech/$path_name"
    sudo chmod -R 755 "/var/www/$subdomain.moealsir.tech/$path_name"

    # Create a test index.html file
    sudo sh -c "echo '<html><head><title>Welcome to $subdomain.moealsir.tech</title></head><body><h1>Success! The path $path_name has been created for $subdomain.moealsir.tech</h1></body></html>' > /var/www/$subdomain.moealsir.tech$path_name/index.html"

    # Inform user about completion
    echo "Path created successfully for the subdomain $subdomain.moealsir.tech."
}

# Main script
if [ $# -lt 1 ]; then
    echo "Usage: $0 <path>"
    echo "       $0 <subdomain> <path>"
    exit 1
fi

# If the user provides two arguments, assume it's for a subdomain
if [ $# -eq 2 ]; then
    subdomain=$1
    path_name=$2
    create_subdomain_path "$subdomain" "$path_name"
else
    path_name=$1
    create_main_domain_path "$path_name"
fi
