#!/bin/bash

# Create a file
touch mysuidfile

if [ $? -ne 0 ]; then
    echo "Error creating file!"
    exit 1
fi

# Set SETUID on the file
chmod +x mysuidfile
chmod u+s mysuidfile

if [ $? -ne 0 ]; then
    echo "Error setting SETUID!"
    exit 2
fi

# Verify that the SETUID was set correctly
perms=$(ls -l mysuidfile)
if [[ $perms != *s* ]]; then
    echo "SETUID was not set correctly!"
    exit 3
else
    echo "SETUID was set correctly."
fi

# Create a directory
mkdir mysgiddir

# Set SETGID on the directory
chmod g+s mysgiddir

if [ $? -ne 0 ]; then
    echo "Error setting SETGID!"
    exit 4
fi

# Verify that the SETGID was set correctly
perms=$(ls -ld mysgiddir)
if [[ $perms != *s* ]]; then
    echo "SETGID was not set correctly!"
    exit 5
else
    echo "SETGID was set correctly."
fi
# Create a directory
mkdir mystickybitdir
# Set Sticky Bit on the directory
chmod o+t mystickybitdir

if [ $? -ne 0 ]; then
    echo "Error setting Sticky Bit!"
    exit 6
fi

# Verify that the Sticky Bit was set correctly
perms=$(ls -ld mystickybitdir)
if [[ $perms != *t* ]]; then
    echo "Sticky Bit was not set correctly!"
    exit 7
else
    echo "Sticky Bit was set correctly."
fi

# Clean up
rm mysuidfile 
rmdir mysgiddir
rmdir mystickybitdir

if [ $? -ne 0 ]; then
    echo "Error deleting files and  directory!"
    exit 8
fi

exit 0
