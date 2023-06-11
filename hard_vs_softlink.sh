#!/bin/bash

# Create a new file
echo "The comparison between hard and soft link" > testfile

# Create a hardlink to this file
ln testfile hardlink

# Create a softlink to this file
ln -s testfile softlink

# Display the inode number to these files
echo "Inode numbers: "
ls -li testfile hardlink softlink

# Modify the content of the original file
echo "Updating contents" > testfile

# Let's view the content of original, softlink and hardlink file
echo "Contents of the original file"
cat testfile
echo "Contents of the hardlink file"
cat hardlink
echo "Contents of the softlink file"
cat softlink

# Let's remove the original file
rm testfile

# Let's check if we can still access the content of the file through the hard and soft link
echo "Content of the hardlink after deleting the original file"
cat hardlink
echo "Content of the softlink after deleting the original file"
cat softlink
