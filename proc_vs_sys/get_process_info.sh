#!/bin/bash

# Get the process ID
pid="$1"

# Check if the process ID is provided
if [ $# -lt 1 ]; then
    echo "Please provide the process ID"
    exit 1
fi

# Display the command line of the process
echo "The command line for the process $pid"
cat /proc/$pid/cmdline
echo

# Display the environment variable for the process
echo "The command line for the process $pid"
cat /proc/$pid/environ
echo

# Display the status of the process
echo "Status of the process $pid"
cat /proc/$pid/status
