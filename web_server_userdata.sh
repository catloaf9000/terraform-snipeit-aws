#!/bin/bash
exec > /home/ubuntu/user-data.log 2>&1
# Update and upgrade the system
sudo apt-get update && sudo apt-get upgrade -y 

# Install prerequisite packages
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Create a directory for Docker's GPG key
sudo mkdir -p /etc/apt/keyrings

# Download and save Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker's APT repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list to include Docker packages
sudo apt-get update

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
docker -v

# Add your user to the docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker ubuntu

# Start a new shell session with the docker group
newgrp docker

# create snipe-it config file
cat <<EOL > /home/ubuntu/my_env_file
# Mysql Parameters
MYSQL_PORT_3306_TCP_ADDR=${MYSQL_PORT_3306_TCP_ADDR}
MYSQL_PORT_3306_TCP_PORT=${MYSQL_PORT_3306_TCP_PORT}

MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Email Parameters
# - the hostname/IP address of your mailserver
MAIL_PORT_587_TCP_ADDR=smtp.whatever.com
#the port for the mailserver (probably 587, could be another)
MAIL_PORT_587_TCP_PORT=587
# the default from address, and from name for emails
MAIL_ENV_FROM_ADDR=youremail@yourdomain.com
MAIL_ENV_FROM_NAME=Your Full Email Name
# - pick 'tls' for SMTP-over-SSL, 'tcp' for unencrypted
MAIL_ENV_ENCRYPTION=tcp
# SMTP username and password
MAIL_ENV_USERNAME=your_email_username
MAIL_ENV_PASSWORD=your_email_password

# Snipe-IT Settings
APP_ENV=production
APP_DEBUG=false
APP_KEY=${APP_KEY}
APP_URL=http://PUBLIC_IP_ADDRESS
APP_TIMEZONE=${APP_TIMEZONE}
APP_LOCALE=${APP_LOCALE}

# Docker-specific variables
PHP_UPLOAD_LIMIT=100
EOL

sed -i "s/PUBLIC_IP_ADDRESS/$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)/g" /home/ubuntu/my_env_file

docker run -d -p 80:80 --name="snipeit" --env-file=/home/ubuntu/my_env_file --mount source=snipe-vol,dst=/var/lib/snipeit snipe/snipe-it