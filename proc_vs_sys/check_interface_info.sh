#!/bin/bash

# Get the process ID
interface="$1"

# Check if the Interface ID is provided
if [ $# -lt 1 ]; then
    echo "Please provide the interface ID"
    exit 1
fi

# Display the Mac Address of the interface
echo "Mac address for the interface $interface"
cat /sys/class/net/$interface/address
echo

# Display the MTU of the interface
echo "MTU for the interface $interface"
cat /sys/class/net/$interface/mtu
echo

# Display the operational state of the interface
echo "Operational state for the $interface"
cat /sys/class/net/$interface/operstate
