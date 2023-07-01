#!/bin/bash

# Printing the real and effective user ID before SUID bit is set
echo "Printing the real and effective user ID before SUID bit is set"
./showid

# Changing the ownership of the file to root user
echo "Changing the ownership of the file to root user"
sudo chown root:root ./setid

# Setting the SUID bit
echo "Setting the SUID bit"
sudo chmod u+s ./showid

# Printing the real and effective user ID after SUID bit is set 
echo "Printing the real and effective user ID after SUID bit is set"
./showid
