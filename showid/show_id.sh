#!/bin/bash

# Check if the filename is provided
if [ $# -lt 1 ]; then
    echo "Please provide the file or directory name"
    exit 1
fi

# Fetch current permissions
perms=$(stat -c "%a" "$1")

# Check with user if he want to setup the SUID, SGID or Sticky Bit
read -p "Do you want to setup the SUID bit? (yes/no): " suid
read -p "Do you want to setup the SGID bit? (yes/no): " sgid
read -p "Do you want to setup the Sticky bit? (yes/no): " sticky

# Setup SUID, SGID or Sticky Bit if not already set
if [ "$suid" == "yes" ]; then
    if (( (perms & 04000) != 04000 )); then
        chmod u+s "$1"
    else
        echo "SUID bit is already set."
    fi
fi

if [ "$sgid" == "yes" ]; then
    if (( (perms & 02000) != 02000 )); then
        chmod g+s "$1"
    else
        echo "SGID bit is already set."
    fi
fi

if [ "$sticky" == "yes" ]; then
    if (( (perms & 01000) != 01000 )); then
        chmod o+t "$1"
    else
        echo "Sticky bit is already set."
    fi
fi

# Display the permission
ls -l "$1"
