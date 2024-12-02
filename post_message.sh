#!/bin/bash

# get sender, receiver, and message as arguments
sender=$1
receiver=$2
message=$3

# check if sender exists
if [ ! -d "$sender" ]; then
    echo "nok: user '$sender' does not exist"  # if sender doesn't exist, show error
    exit 1  # exit if sender is not found
fi

# check if receiver exists
if [ ! -d "$receiver" ]; then
    echo "nok: user '$receiver' does not exist"  # if receiver doesn't exist, show error
    exit 1  # exit if receiver is not found
fi

# check if sender is a friend of receiver
if ! grep -q "^$sender$" "$receiver/friends.txt"; then
    echo "nok: user '$sender' is not a friend of '$receiver'"  # if not friends, show error
    exit 1  # exit if sender isn't in receiver's friends list
fi

# post the message on receiver's wall
echo "$sender: $message" >> "$receiver/wall.txt"  # add message to receiver's wall file

# success message
echo "ok: message posted!"  # let the user know the message was posted

