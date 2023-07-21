#!/bin/bash

# Name of the log file
LOGFILE="/var/log/secure"

# The threshold for blocking an IP address(Please modify it based on your requirement)
THRESHOLD=5

# Check if the log file exists and is readable
if [[ ! -e "$LOGFILE" ]]; then
    echo "Error: $LOGFILE does not exist." >&2
    exit 1
elif [[ ! -r "$LOGFILE" ]]; then
    echo "Error: $LOGFILE is not readable." >&2
    exit 1
fi

# Create a timestamp, this we will use with temporary file
timestamp=$(date +%Y%m%d%H%M%S)

# Use the above timestamp to create temporary file to store the unique IP
TMPFILE=$(mktemp /tmp/ip_list."$timestamp".XXXXX) || { echo "Error: Failed to create temporary file."; exit 1; }

# Extract the IP addresses from the log file and count the number of occurence
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$LOGFILE" | sort | uniq -c > "$TMPFILE"

while read -r line; do
    # Get the count of IP address(first field) and IP address(second field)
    COUNT=$(echo "$line" | awk '{print $1}')
    IP=$(echo "$line" | awk '{print $2}')

    # If the count of IP address is greater than threshold, block the particular IP address
    if [[ "$COUNT" -ge "$THRESHOLD" ]]; then
            echo "Blocking IP $IP"
            iptables -A INPUT -s "$IP" -j DROP || { echo "Error: Failed to block IP $IP"; exit 1; }
    fi
done < "$TMPFILE"

# Remove the temporary file
rm "$TMPFILE" || { echo "Error: Failed to remove temp file."; exit 1; }
