#!/bin/bash

# ASCII Art Banner
AUTOCLICKER_TEXT="""\033[95m
   ___ _       _       ___     _          _ _  
  /   | |     | |     /   |   | |        | | |
 / /| | |_ __ | |__  / /| |___| |__   ___| | |
/ /_| | | '_ \| '_ \/ /_| / __| '_ \ / _ \ | |
\___  | | |_) | | | \___  \__ \ | | |  __/ | |
    |_/_| .__/|_| |_|   |_/___/_| |_|\___|_|_|
        | |                                   
        |_|                                   
\033[0m"""

echo -e "$AUTOCLICKER_TEXT"

# Define default values
DEFAULT_DOMAIN="alphashell.com"
DEFAULT_sslDOMAIN="gmail.com"
DEFAULT_CUSTOMIZE="y"
DEFAULT_USERNAME="4lph4shell747"
DEFAULT_PASSWORD="4lph4shell@747"
DEFAULT_PORT="53747"
DEFAULT_WEB_BASE_PATH="/alphashell"

# Create a menu for user input with defaults
read -p "Enter ssl email domain (default: $DEFAULT_sslDOMAIN): " sslDOMAIN
sslDOMAIN=${sslDOMAIN:-$DEFAULT_sslDOMAIN}

read -p "Enter your Domain Name (default: $DEFAULT_DOMAIN): " DOMAIN
DOMAIN=${DOMAIN:-$DEFAULT_DOMAIN}

read -p "Enter username (default: $DEFAULT_USERNAME): " username
username=${username:-$DEFAULT_USERNAME}

read -p "Enter password (default: $DEFAULT_PASSWORD): " password
password=${password:-$DEFAULT_PASSWORD}

read -p "Enter port number (default: $DEFAULT_PORT): " port
port=${port:-$DEFAULT_PORT}

read -p "Enter web base path (default: $DEFAULT_WEB_BASE_PATH): " web_base_path
web_base_path=${web_base_path:-$DEFAULT_WEB_BASE_PATH}

# Generate random username if needed
USERNAME=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8)
EMAIL="${USERNAME}@${sslDOMAIN}"

echo "Randomized Email: $EMAIL"

# Run the following commands with sudo
sudo -i <<EOF
apt update
apt install curl -y
apt install socat -y
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m $EMAIL
~/.acme.sh/acme.sh --issue -d $DOMAIN --standalone

# Attempt to install the certificate and show the result in the terminal
if ~/.acme.sh/acme.sh --installcert -d $DOMAIN --key-file /root/private.key --fullchain-file /root/cert.crt; then
    echo "Certificate installation successful."
else
    echo "Certificate installation failed."
fi
EOF

# Run the second script and provide the answers
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) << EOF
$customize
$username
$password
$port
$web_base_path
EOF
