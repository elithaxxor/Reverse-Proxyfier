#!/bin/bash

# Variables
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"
CONFIG_FILE="reverse-proxy"
BACKEND_SERVER="http://127.0.0.1:8000" # Replace with your backend server address
SERVER_NAME="localhost" # Replace with your domain name if needed

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo." 
   exit 1
fi

# Step 1: Create a new Nginx configuration file
echo "Creating Nginx reverse proxy configuration..."
cat > $NGINX_SITES_AVAILABLE/$CONFIG_FILE <<EOL
server {
    listen 80;
    server_name $SERVER_NAME;

    location / {
        proxy_pass $BACKEND_SERVER;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

echo "Configuration file created at $NGINX_SITES_AVAILABLE/$CONFIG_FILE"

# Step 2: Link the configuration file to the sites-enabled directory
echo "Activating the configuration..."
ln -s $NGINX_SITES_AVAILABLE/$CONFIG_FILE $NGINX_SITES_ENABLED/$CONFIG_FILE

# Step 3: Test the Nginx configuration for syntax errors
echo "Testing Nginx configuration..."
nginx -t
if [[ $? -ne 0 ]]; then
    echo "Nginx configuration test failed. Please check your configuration."
    exit 1
fi

# Step 4: Restart Nginx to apply changes
echo "Restarting Nginx..."
systemctl restart nginx

if [[ $? -eq 0 ]]; then
    echo "Nginx reverse proxy setup completed successfully!"
else
    echo "Failed to restart Nginx. Please check the logs for more information."
fi
