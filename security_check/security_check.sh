#!/bin/bash

# Define different color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

# Check if Password Authentication is disabled for SSH
if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo -e "${GREEN}Password Authentication is disabled for SSH${NO_COLOR}"
else
    echo -e "${RED}Error: Password Authentication is not disabled for SSH${NO_COLOR}"
fi

# Check if root login is disabled for SSH
if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo -e "${GREEN}Root login is disabled for SSH${NO_COLOR}"
else
    echo -e "${RED}Error: Root login is not disabled for SSH${NO_COLOR}"
fi

# Check if SELinux is enforcing
if getenforce | grep -q 'Enforcing'; then
    echo -e "${GREEN}SELinux is enforcing${NO_COLOR}"
else
    echo -e "${RED}Error: SELinux is not enforcing${NO_COLOR}"
fi

# Check for unwanted services for eg: cups
if systemctl is-active --quiet cups; then
    echo -e "${RED}Error: cups service is running${NO_COLOR}"
else
    echo -e "${GREEN}cups service is not running${NO_COLOR}"
fi

# Check if firewall is running 
if systemctl is-active --quiet firewalld; then
    echo -e "${GREEN}Firewall is active${NO_COLOR}"
else
    echo -e "${RED}Error: Firewall is not active${NO_COLOR}"
fi

# Check if system packages are up-to-date
# NOTE: yum check-update will return an exit code of 100 if updates are available and 0 if not, which can make it seem like an error has occurred even if the command was successful 
if yum check-update; then
    echo -e "${GREEN}System packages are up-to-date${NO_COLOR}"
else
    echo -e "${RED}Error: System packages are not up-to-date${NO_COLOR}"
fi
